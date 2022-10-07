#!/usr/bin/env python3
from pathlib import Path
from typing import Any

import yaml


def main() -> None:
    packages = [p.parent.name for p in sorted(Path.cwd().glob('*/PKGBUILD'))]
    workflow = generate_workflow(packages)
    text = yaml.safe_dump(workflow, indent=2, sort_keys=False)
    Path.cwd().joinpath('.github/workflows/ci.yaml').write_text(text)


def generate_workflow(packages: list[str]) -> dict[str, Any]:
    return {
        'name': 'CI',
        'permissions': {
            'contents': 'write',
            'packages': 'write',
        },
        'on': {
            'push': {
                'branches': [
                    'main',
                ],
            },
            'schedule': [
                {'cron': '0 3 * * *'},
            ],
        },
        'jobs': {'build-container': generate_setup_job(), 'deploy-pages': generate_deploy_job(packages)} | {f'package-{package}': generate_package_job(package) for package in packages},
    }


def generate_package_job(package: str) -> dict[str, Any]:
    return {
        'runs-on': 'ubuntu-20.04',
        'needs': ['build-container'],
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v3',
                'with': {
                    'fetch-depth': 0,
                }
            },
            {
                'name': 'Build package',
                'run': f'./build-package.sh {package}',
            },
            {
                'name': 'Upload package',
                'uses': 'actions/upload-artifact@v3',
                'with': {
                    'name': f'package-{package}',
                    'path': f'./{package}/*.pkg.tar.zst',
                    'retention-days': 1,
                    'if-no-files-found': 'error',
                }
            }
        ],
    }


def generate_setup_job() -> dict[str, Any]:
    return {
        'runs-on': 'ubuntu-20.04',
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v3',
                'with': {
                    'fetch-depth': 0,
                }
            },
            {
                'name': 'Build and push container',
                'run': './build-container.sh',
                'env': {
                    'GITHUB_USER': 'dadevel',
                    'GITHUB_TOKEN': '${{ secrets.GITHUB_TOKEN }}'
                },
            },
        ],
    }


def generate_deploy_job(packages: list[str]) -> dict[str, Any]:
    return {
        'runs-on': 'ubuntu-20.04',
        'needs': [f'package-{name}' for name in packages],
        'concurrency': 'ci-${{ github.ref }}',
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v3',
                'with': {
                    'fetch-depth': 0,
                }
            },
            {
                'name': 'Download artifacts',
                'uses': 'actions/download-artifact@v3',
                'with': {
                    'path': './artifacts',
                }
            },
            {
                'name': 'Create repository',
                'run': './build-repo.sh',
            },
            {
                'name': 'Deploy pages',
                'uses': 'peaceiris/actions-gh-pages@v3',
                'with': {
                    'github_token': '${{ secrets.GITHUB_TOKEN }}',
                    'publish_dir': './public',
                    'force_orphan': True,  # dont keep history in gh-pages branch
                    'user_name': 'github-actions[bot]',  # commit author
                    'user_email': 'github-actions[bot]@users.noreply.github.com',
                }
            },
        ],
    }


if __name__ == '__main__':
    main()
