// Define a preset
Babel.registerPreset("env-plus", {
    presets: [[Babel.availablePresets["env"], { modules: false }]],  
  });