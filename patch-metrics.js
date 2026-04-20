const fs = require('fs');
const path = 'air-mentor-api/scripts/evaluate-proof-risk-model.ts';
let content = fs.readFileSync(path, 'utf8');

content = content.replace(
  /type ThresholdMetrics = \{/,
  `type BudgetMetrics = {
  budgetRate: number
  thresholdAtBudget: number
  flaggedRateAtBudget: number
  precisionAtBudget: number
  recallAtBudget: number
  overloadRatio: number
}

type ThresholdMetrics = {`
);

content = content.replace(
  /  highThreshold: ThresholdMetrics\n\}/,
  `  highThreshold: ThresholdMetrics
  budgetMetrics: BudgetMetrics
}`
);

content = content.replace(
  /function summarizeThresholdMetrics/,
  `function summarizeBudgetMetrics(rows: ProbabilityRow[], budgetRate: number): BudgetMetrics {
  if (!rows.length) {
    return {
      budgetRate,
      thresholdAtBudget: 0,
      flaggedRateAtBudget: 0,
      precisionAtBudget: 0,
      recallAtBudget: 0,
      overloadRatio: 0,
    }
  }
  const ordered = [...rows].sort((left, right) => right.prob - left.prob)
  const budgetCount = Math.max(1, Math.floor(rows.length * budgetRate))
  const thresholdAtBudget = ordered[budgetCount - 1]?.prob ?? 0
  
  let flaggedCount = 0
  let truePositives = 0
  let positiveCount = 0
  rows.forEach(row => {
    if (row.label === 1) positiveCount += 1
    if (row.prob >= thresholdAtBudget) {
      flaggedCount += 1
      if (row.label === 1) truePositives += 1
    }
  })
  
  const flaggedRateAtBudget = flaggedCount / rows.length
  const overloadRatio = budgetRate > 0 ? flaggedRateAtBudget / budgetRate : 0
  
  return {
    budgetRate,
    thresholdAtBudget: roundToFour(thresholdAtBudget),
    flaggedRateAtBudget: roundToFour(flaggedRateAtBudget),
    precisionAtBudget: roundToFour(flaggedCount > 0 ? truePositives / flaggedCount : 0),
    recallAtBudget: roundToFour(positiveCount > 0 ? truePositives / positiveCount : 0),
    overloadRatio: roundToFour(overloadRatio),
  }
}

function summarizeThresholdMetrics`
);

content = content.replace(
  /function summarizeMetrics\(rows: ProbabilityRow\[\]\): HeadMetrics \{/,
  `function summarizeMetrics(rows: ProbabilityRow[], budgetRate = 0.20): HeadMetrics {`
);

content = content.replace(
  /    highThreshold: summarizeThresholdMetrics\(rows, PRODUCTION_RISK_THRESHOLDS\.high\),\n  \}/,
  `    highThreshold: summarizeThresholdMetrics(rows, PRODUCTION_RISK_THRESHOLDS.high),
    budgetMetrics: summarizeBudgetMetrics(rows, budgetRate),
  }`
);

fs.writeFileSync(path, content);
