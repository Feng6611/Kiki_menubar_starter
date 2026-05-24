# Documentation Practices

This starter carries the default docs habit for new Kiki-based Mac apps.

The goal is not more documents. The goal is to make product scope, platform
risk, and recovery behavior easy to understand later.

## Best Practice

Use docs to answer four questions:

1. What problem does this app solve?
2. What is the current solution and boundary?
3. What platform risks exist and how does the app fail safely?
4. Why did we choose this path instead of the tempting alternatives?

If a document does not answer one of those questions, it is probably noise.

## Default Docs Set

### `docs/Architecture.md`

Use this for current system shape.

Include:

- one-paragraph app summary;
- directory and layer responsibilities;
- Kiki API boundary;
- platform permissions and APIs;
- safety and recovery model;
- explicit non-goals;
- verification commands.

Do not turn it into a design diary. It should describe the current truth.

### `docs/PRD.md`

Use this for product intent.

Include:

- user problem;
- target user;
- MVP scope;
- explicitly out of scope;
- product behavior;
- privacy expectations;
- success criteria.

### `docs/DecisionLog.md`

Use this only when decisions have real tradeoffs.

Good entries explain:

- decision;
- why;
- implication;
- superseded decisions if any.

Use DecisionLog for:

- Accessibility behavior;
- event taps;
- status item layout;
- activation policy;
- window restoration;
- permission boundaries;
- paywall or access gating that affects recovery;
- any choice where a future cleanup might break the product.

### `docs/IssueLog.md`

Use this for non-obvious bugs and open risks.

Good entries include:

- symptoms;
- root cause;
- fixes landed;
- remaining risk;
- possible directions;
- recommendation.

IssueLog is not a bug tracker replacement. It is for hard-won knowledge that
prevents repeating the same failure.

## When To Create Which Docs

For a simple app:

- `docs/Architecture.md`
- `docs/PRD.md`

For a platform-risk app:

- `docs/Architecture.md`
- `docs/PRD.md`
- `docs/DecisionLog.md`
- `docs/IssueLog.md`

Platform-risk means the app depends on behavior such as:

- Accessibility;
- `CGEventTap`;
- `NSStatusItem` geometry, ordering, or hiding;
- activation policy;
- `NSWorkspace` window or application behavior;
- pasteboard or sharing flows with privacy expectations;
- paid access gating around safety or recovery paths.

## Starter Adoption Rule

When creating a new app from this starter:

1. copy the matching files from `Docs/Templates/MacAppDocs/`;
2. replace placeholders with the product's real problem, boundaries, and risks;
3. remove unused sections instead of leaving fake completeness;
4. keep Kiki as API infrastructure and keep product behavior in the app docs.

When changing an existing app:

- update `Architecture.md` when directories, ownership, Kiki usage, platform
  APIs, safety behavior, or recovery paths change;
- update `PRD.md` when user-facing behavior, MVP scope, pricing, trial,
  onboarding, or privacy expectations change;
- update `DecisionLog.md` when choosing between platform approaches or
  rejecting an obvious alternative;
- update `IssueLog.md` when a bug took investigation to understand or a
  workaround encodes platform knowledge.

