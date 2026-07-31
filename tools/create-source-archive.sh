#!/usr/bin/env bash

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
ref="${1:-HEAD}"
version="$(git -C "$repo_root" show "${ref}:version.txt" | tr -d '[:space:]')"
output="${2:-arm-cmsis-nn-${version}.tar.gz}"

case "$output" in
  /*) ;;
  *) output="$PWD/$output" ;;
esac

commit="$(git -C "$repo_root" rev-parse "${ref}^{commit}")"
prefix="arm-cmsis-nn-${version}"
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT
mkdir -p "$staging/$prefix"

while IFS= read -r status; do
  case "$status" in
    " "*) ;;
    *)
      echo "Submodule is missing or differs from ${commit}: ${status}" >&2
      exit 1
      ;;
  esac
done < <(git -C "$repo_root" submodule status --recursive)

git -C "$repo_root" archive --format=tar "$commit" \
  | tar -xf - -C "$staging/$prefix"

export archive_root="$staging/$prefix"
git -C "$repo_root" submodule foreach --quiet --recursive '
  destination="${archive_root}/${displaypath}"
  mkdir -p "$destination"
  git archive --format=tar HEAD | tar -xf - -C "$destination"
'

mkdir -p "$(dirname "$output")"
COPYFILE_DISABLE=1 tar -czf "$output" -C "$staging" "$prefix"
printf '%s\n' "$output"
