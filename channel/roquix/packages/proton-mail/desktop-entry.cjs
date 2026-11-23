const { createDesktopFile, getDefaultsFromPackageJSON } = require('electron-installer-common');
const { default: forge } = require('./forge.config.ts');

const { options } = forge.makers.find(maker => maker.name === '@electron-forge/maker-deb').config;
const metadata = getDefaultsFromPackageJSON(require('./package.json'));

createDesktopFile(
    require.resolve('electron-installer-debian/resources/desktop.ejs'),
    process.argv[2],
    options.name,
    {
        ...metadata,
        ...options,
        // The Guix launcher also accepts Proton's inbox notification links.
        mimeType: [...new Set([...options.mimeType, 'x-scheme-handler/proton-inbox'])],
    },
).catch(error => { console.error(error); process.exitCode = 1; });
