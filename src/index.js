'use strict';

function isPipelineSuccessful(status) {
  return status === 'SUCCESS';
}

module.exports = {
  isPipelineSuccessful
};
