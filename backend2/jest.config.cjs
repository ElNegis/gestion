// jest.config.cjs
module.exports = {
    testEnvironment: 'node',
    // No necesitamos extensionsToTreatAsEsm ni transform
    transform: {},
    testMatch: ['**/test/**/*.test.js'],
    reporters: [
      'default',
      ['jest-junit', {
        outputDirectory: './junit',
        outputName: 'results.xml'
      }]
    ],
  };
  