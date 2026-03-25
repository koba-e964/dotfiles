---
name: mckinsey-7s-analysis
description: Analyze an organization with the McKinsey 7S framework. Use when the user wants to assess Shared Values, Strategy, Skills, Structure, Systems, Staff, and Style, identify misalignment across the seven elements, or turn observations into a structured diagnosis and recommendations.
---

# McKinsey 7S Analysis

## Overview

Use this skill to analyze an organization through seven connected elements:

- Shared Values
- Strategy
- Skills
- Structure
- Systems
- Staff
- Style

Treat the framework as an alignment model, not a checklist. The objective is to explain how the seven elements reinforce or conflict with one another.

## Working Rules

- Start by clarifying the target organization, scope, and time horizon if they are not already clear.
- Separate facts, inferences, and hypotheses. Label uncertain claims explicitly.
- Prefer concrete evidence such as observed behaviors, org design choices, processes, incentives, decision rights, hiring patterns, and operating metrics.
- Do not produce generic strengths and weaknesses without linking them to business outcomes or cross-element alignment.
- When the user uses `Shared Value` or `Skill`, normalize internally to the standard 7S labels `Shared Values` and `Skills`, but preserve the user's wording in the final output if that is preferable.

## Analysis Flow

### 1. Frame the problem

Identify:

- Organization or unit being analyzed
- Purpose of the analysis
- Current context: growth, turnaround, PMI, transformation, scale-up, stagnation, etc.
- Decision the analysis should support

### 2. Gather evidence for each S

For each element, capture:

- Current state
- Evidence
- Strengths
- Gaps or tensions
- Impact on other elements

Use these prompts:

#### Shared Values

- What core beliefs or priorities actually drive decisions?
- What gets rewarded, protected, or deprioritized in practice?
- Is there a gap between stated values and lived behavior?

#### Strategy

- How does the organization intend to win?
- What tradeoffs has it chosen?
- Are priorities coherent and understood by the organization?

#### Skills

- Which capabilities are genuinely differentiated?
- Which capabilities are missing, shallow, or too concentrated in a few people?
- Are critical skills aligned to strategic needs?

#### Structure

- How are roles, teams, and decision rights arranged?
- Where do accountability and ownership break down?
- Does the structure help or hinder execution?

#### Systems

- Which formal processes, metrics, planning loops, controls, and tools shape day-to-day work?
- Do the systems reinforce desired behavior or create friction?
- Where are there bottlenecks, delays, or inconsistent execution?

#### Staff

- What does the talent mix look like?
- Are headcount, seniority, and staffing patterns fit for the strategy?
- Where are there hiring, retention, or bench-strength issues?

#### Style

- How do leaders actually lead?
- How are decisions made, escalations handled, and conflicts resolved?
- Does leadership style support the desired culture and execution model?

### 3. Diagnose alignment

Look for:

- Reinforcing loops across multiple elements
- Direct contradictions between elements
- Root causes that explain several symptoms
- Misalignments between soft elements (`Shared Values`, `Skills`, `Staff`, `Style`) and hard elements (`Strategy`, `Structure`, `Systems`)

Useful diagnosis patterns:

- Strategy asks for speed, but structure and systems centralize decisions.
- Shared values emphasize empowerment, but leadership style remains top-down.
- Staff composition supports maintenance, not innovation.
- Strong individual skills exist, but systems prevent scaling them.

### 4. Prioritize issues

Rank issues by:

- Business impact
- Urgency
- Breadth of cross-element effects
- Ease or difficulty of change

Prefer a small number of high-leverage findings over a long unranked list.

### 5. Recommend actions

Recommendations should:

- Target the most important misalignments
- Name which S elements need to change
- Explain expected effects and tradeoffs
- Distinguish near-term actions from structural longer-term changes

## Output Format

Use this structure unless the user requests another format:

```markdown
# 7S Analysis: <organization>

## Executive Summary
- Overall diagnosis
- Most important alignment or misalignment
- Main implication

## Snapshot by S
| Element | Current state | Evidence | Key issue |
| --- | --- | --- | --- |
| Shared Values |  |  |  |
| Strategy |  |  |  |
| Skills |  |  |  |
| Structure |  |  |  |
| Systems |  |  |  |
| Staff |  |  |  |
| Style |  |  |  |

## Cross-S Alignment
- Reinforcing patterns
- Contradictions
- Root causes

## Priority Issues
1. <issue>
2. <issue>
3. <issue>

## Recommendations
| Recommendation | Target S elements | Rationale | Time horizon |
| --- | --- | --- | --- |
|  |  |  |  |

## Open Questions
- Missing information that would change the diagnosis
```

## When Information Is Incomplete

If the user has limited input:

- State the confidence level.
- Use a hypothesis-driven assessment instead of pretending certainty.
- Ask for the smallest additional facts that would most improve the analysis.
- Prefer 3 to 5 focused follow-up questions over a long questionnaire.
