'use strict';

const express = require('express');
const packageJson = require('../package.json');

function isPipelineSuccessful(status) {
  return status === 'SUCCESS';
}

function createApp() {
  const app = express();

  const appVersion =
    process.env.APP_VERSION ||
    `${packageJson.version}-${process.env.GIT_SHA || 'local'}`;

  app.use(express.json());

  app.get('/', (req, res) => {
    res.status(200).json({
      service: 'kk-payments',
      message: 'KijaniKiosk payments service is running',
      version: appVersion
    });
  });

  app.get('/health', (req, res) => {
    res.status(200).json({
      status: 'ok',
      service: 'kk-payments',
      version: appVersion
    });
  });

  app.get('/payments/status', (req, res) => {
    res.status(200).json({
      status: 'available',
      service: 'kk-payments',
      version: appVersion
    });
  });

  return app;
}

if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  const app = createApp();

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`kk-payments service running on port ${PORT}`);
  });
}

module.exports = {
  isPipelineSuccessful,
  createApp
};