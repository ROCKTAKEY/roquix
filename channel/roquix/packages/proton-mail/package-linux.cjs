const fs = require('node:fs');
const path = require('node:path');
const { isBuiltin } = require('node:module');
const { createPackage } = require('@electron/asar');
const { flipFuses } = require('@electron/fuses');
const { createDesktopFile } = require('electron-installer-common/src/desktop');
const defaults = require('electron-installer-common/src/defaults');
const { default: forge } = require('./forge.config.ts');
const { default: mail } = require('../mail/appConfig.ts');
const pkg = require('./package.json');

async function main(action, argument) {
    if (action === 'metadata') {
        const defines = {
            '__SENTRY_SDK_VERSION__': require('@sentry/core/package.json').version,
            'process.env.DESKTOP_SENTRY_DSN': mail.sentryDesktop,
            'process.env.BUILD_TAG': 'ida-' + pkg.version,
            'process.env.IS_SNAP': undefined,
            'process.env.IDA_TAG': undefined,
            'process.env.PLAYWRIGHT_TEST': undefined,
        };
        fs.writeFileSync('defines', Object.entries(defines).map(([name, value]) =>
            '--define:' + name + '=' + JSON.stringify(value)).join('\n'));
    } else if (action === 'audit') {
        for (const output of Object.values(JSON.parse(fs.readFileSync(argument)).outputs)) {
            for (const dependency of output.imports) {
                if (dependency.external && !isBuiltin(dependency.path) &&
                    !['electron', '../../preload/default.js'].includes(dependency.path)) {
                    throw Error('Unpackaged dependency: ' + dependency.path);
                }
            }
        }
    } else if (action === 'package') {
        const { executableName, extraResource } = forge.packagerConfig;
        const executable = path.join('out', executableName);
        fs.renameSync('out/electron', executable);
        await flipFuses(executable, forge.plugins[1]);
        fs.unlinkSync('out/resources/default_app.asar');
        for (const file of extraResource) {
            fs.copyFileSync(file, path.join('out/resources', path.basename(file)));
        }
        await createPackage('app', 'out/resources/app.asar');
        const { options } = forge.makers.find(maker => maker.name === '@electron-forge/maker-deb').config;
        await createDesktopFile(path.join(process.env.NODE_PATH, 'electron-installer-debian/resources/desktop.ejs'),
            argument, options.name, { ...defaults(pkg), ...options,
                mimeType: [...new Set([...options.mimeType, 'x-scheme-handler/proton-inbox'])] });
    }
}
main(...process.argv.slice(2)).catch(error => { console.error(error); process.exitCode = 1; });
