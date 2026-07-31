# Release policy

This module uses SemVer independently from upstream CMSIS-NN. `v0.1.0` is the
correct first release because this repository has no earlier tags or releases,
its public wrapper contract is new, and the previous `7.26.0` catalog value
belongs to a different repository/version line rather than either pinned
upstream revision.

`nsx-module.yaml`, `version.txt`, and `.release-please-manifest.json` must always
contain the same version.

## Immutable release rules

- Release tags are annotated `vMAJOR.MINOR.PATCH` tags.
- The peeled tag target is the reviewed commit containing the matching version
  and exact provenance.
- Published tags and GitHub releases are never moved, replaced, or deleted.
- The publisher refuses an existing tag when asked to publish.
- Publishing is a manual workflow dispatch after explicit maintainer approval;
  it is never triggered merely by merging a release PR.
- The publisher requires successful hosted CI for the exact candidate commit.
- Release archives are built from the tag and include both pinned submodules.
- Archive rebuilds may update release assets but must not create or retarget a
  tag; the workflow verifies the existing annotated tag and its CI result.
- Downstream registry pins are separate changes and are never updated by this
  repository's release automation.

## First release

1. Review and merge the non-draft release-preparation PR only after all hosted
   CI and review feedback is complete and a maintainer explicitly approves.
2. Verify the merge commit is the head of `main`.
3. Dispatch the `Release Please` workflow on `main` with `operation=publish`
   and `tag=v0.1.0`.
4. Verify the annotated tag, peeled commit, generated release, source archive,
   checksum, and included upstream license files.
5. Qualify downstream consumption before proposing any registry-pin update.

Release Please remains gated until the initial `v0.1.0` tag exists. Afterward,
it opens version/changelog PRs from Conventional Commits but skips GitHub
release creation. A maintainer publishes each reviewed release with the same
manual, CI-gated workflow.

To reconstruct a missing or damaged archive without changing a tag, dispatch
the workflow with `operation=rebuild` and the existing tag.

This preparation does not publish a tag or release and stops before merge.
