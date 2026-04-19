'use strict';

const { isPipelineSuccessful } = require('../src/index');

describe('isPipelineSuccessful', () => {
  test('returns true when the pipeline status is SUCCESS', () => {
    expect(isPipelineSuccessful('SUCCESS')).toBe(true);
  });

  test('returns false for non-success pipeline statuses', () => {
    expect(isPipelineSuccessful('FAILED')).toBe(false);
  });
});
