# AIDEV incubation

This directory contains an experimental, provider-neutral AIDEV protocol
fixture. It tests engineering continuity in iOSTG without becoming part of the
app or tutorial runtime.

```yaml
schema_status: draft
applicability: experimental
canonical_project_state: false
operational_authorization: false
```

## Package

- `templates/work-unit.template.yaml` defines one immutable WorkUnit revision.
- `examples/iostg-project-policy.example.yaml` assigns authority by fact domain
  and defines capability and reducer rules for the fixture.
- `examples/iostg-root-onboarding.example.yaml` is a source-backed WorkUnit
  example bound to one exact iOSTG commit.
- `examples/iostg-root-onboarding.events.example.yaml` is a synthetic,
  append-only input stream plus its expected reducer projection.

The policy and event files are example dependencies, not canonical iOSTG
governance and not real authorization records.

## Stable definitions and runtime records

A WorkUnit stores stable intent, scope ceilings, typed requirements, and Gate
transitions. Mutable operational facts remain independent records:

```text
DecisionRevision
CapabilityGrant
Run
Event
Evidence
Acceptance
GateEvaluation
DerivedProjection
```

`DecisionRevision` records a choice. `Acceptance` accepts an exact subject.
`Gate` is a stable rule. `GateEvaluation` is the reducer's result for a precise
input set. None of those concepts may substitute for another.

Current state is never edited into the WorkUnit. It is calculated from an exact
WorkUnit revision, versioned policies, an ordered Event stream, referenced
records, and their digests. Generated projections are disposable and have no
independent authority.

## Safety boundary

- Copying or editing any file here grants no capability.
- Unprivileged `read`, `analyze`, and `propose` do not imply `edit`.
- `edit`, `stage`, `commit`, `push`, `tag`, `deploy`, external mutation, and
  publication require separate matching Grants whenever applicable.
- A Run proves that activity occurred; only matching Evidence can support a
  verification requirement.
- A maintainer Decision does not prove implementation, and an Agent proposal
  cannot create a maintainer Decision or Acceptance.
- Grants are principal-, action-, target-, environment-, revision-, and
  lifetime-bound. A replacement Agent does not inherit a Grant automatically.
- Do not store credentials, private reasoning, full transcripts, simulator
  identifiers, or unredacted user data here.
- iOSTG must continue to build, run, and remain readable if `.aidev/` is absent
  or broken.

Before this fixture can test continuity across clones, it must be deliberately
reviewed and placed under version control. That future Git action is not
authorized by these files.
