# pre-commit-docker-kustomize

A pre-commit hook containing a kustomize docker image. 

The image is based on https://github.com/lyft/kustomizer and 
https://github.com/rl0nergan/pre-commit-docker-kustomize. GitHub.com known 
hosts are added and image does not run as root. This modification allows for remote 
refs in your kustomize.

## Example `.pre-commit-config.yaml`

Verifies kustomize files at four levels deep in the overlays directory

```yaml
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
-   repo: https://github.com/clingclangclick/pre-commit-docker-kustomize
    rev: main
    hooks:
    -   id: kustomize
        name: kustomize
        args: [overlays, 4]
        verbose: false
```