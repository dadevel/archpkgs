#!/usr/bin/env python3
from pathlib import Path
from typing import Any

import yaml

RUNNER_OS = 'ubuntu-24.04'


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
        'jobs': {'build-container': generate_setup_job(), 'deploy-repo': generate_deploy_job(packages)} | {f'package-{package}': generate_package_job(package) for package in packages},
    }


def generate_package_job(package: str) -> dict[str, Any]:
    return {
        'runs-on': RUNNER_OS,
        'needs': ['build-container'],
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v4',
            },
            {
                'name': 'Build package',
                'run': f'./build-package.sh {package}',
            },
            {
                'name': 'Upload package',
                'uses': 'actions/upload-artifact@v4',
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
        'runs-on': RUNNER_OS,
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v4',
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
        'runs-on': RUNNER_OS,
        'needs': [f'package-{name}' for name in packages],
        'if': '${{ always() }}',
        'concurrency': 'ci-${{ github.ref }}',
        'steps': [
            {
                'name': 'Checkout',
                'uses': 'actions/checkout@v4',
            },
            {
                'name': 'Download artifacts',
                'uses': 'actions/download-artifact@v4',
                'with': {
                    'path': './artifacts',
                }
            },
            {
                'name': 'Create repository',
                'run': './build-repo.sh',
                'env': {
                    'SIGNING_KEY': '${{ secrets.SIGNING_KEY }}',
                },
            },
            {
                'name': 'Upload repository',
                'run': 'sudo apt-get install --no-install-recommends -y rclone && rclone --copy-links sync ./public hetzner:',
                'env': {
                    'RCLONE_CONFIG_HETZNER_TYPE': 'ftp',
                    'RCLONE_CONFIG_HETZNER_HOST': '${{ secrets.HETZNER_HOSTNAME }}',
                    'RCLONE_CONFIG_HETZNER_USER': '${{ secrets.HETZNER_USERNAME }}',
                    'RCLONE_CONFIG_HETZNER_PASS': '${{ secrets.HETZNER_PASSWORD }}',  # echo password | rclone obscure
                    'RCLONE_CONFIG_HETZNER_EXPLICIT_TLS': 'true',
                },
            },
        ],
    }


if __name__ == '__main__':
    main()
