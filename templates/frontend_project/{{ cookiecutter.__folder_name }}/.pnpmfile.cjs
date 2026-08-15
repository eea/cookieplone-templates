const fs = require('fs');
const path = require('path');
const catalogPath = path.resolve(__dirname, 'core/catalog.json');
let catalog = {};
if (fs.existsSync(catalogPath)) {
  catalog = JSON.parse(fs.readFileSync(catalogPath, 'utf-8'));
}
module.exports = {
  hooks: {
    updateConfig(config) {
      if (config.catalogs) { config.catalogs.default ??= catalog; }
      return config;
    },
  },
};
