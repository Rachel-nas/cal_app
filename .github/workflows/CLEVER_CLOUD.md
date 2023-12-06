# Clever Cloud deployment

## Setup

### Clever Cloud interface

Create 2 Node.js applications with the `XS` plan:
* `calcom`
* `calcom-staging`

And 2 PostgreSQL databases (version 15) with any plan that you will binding to each app accordingly:
* `calcom`
* `calcom-staging`

_For the staging environment it's fine to choose the database plan named `DEV` (lowest plan), but sometimes it may break with a `FATAL: too many connections` error, so a solution is to add a specific parameter to the database URL (`DATABASE_URL=xxx?connection_limit=1`) to keep connections under the limit._

Now set for both apps these options:
* Zero downtime deployment
* Enable dedicated build instance: `XL`
* Cancel ongoing deployment on new push
* Force HTTPS

Adjust the domain names as you want, and configure the environment variables as follow:
* `ALLOWED_HOSTNAMES`: `"${YOUR_DOMAIN}"` _(format is strict, quotes are required because it can be a list like `"aaa.com","bbb.com"`)_
* `BASE_URL`: `https://${YOUR_DOMAIN}`
* `CALENDSO_ENCRYPTION_KEY`: [SECRET]
* `CC_CACHE_DEPENDENCIES`: `true`
* `CC_CUSTOM_BUILD_TOOL`: `DATABASE_URL="" bash -c 'yarn install && yarn run build --filter=@calcom/web'` _(we set `DATABASE_URL` empty otherwise it tries to deal with the database during the build, which makes no sense)_
* `CC_NODE_BUILD_TOOL`: `custom`
* `CC_PRE_RUN_HOOK`: `yarn run db-deploy`
* `CRON_API_KEY`: [SECRET]
* `DATABASE_URL`: [GENERATED] _(provided by the interface, but you must add as query parameter `sslmode=prefer`)_
* `EMAIL_FROM`: [SECRET]
* `EMAIL_SERVER_HOST`: [SECRET]
* `EMAIL_SERVER_PASSWORD`: [SECRET]
* `EMAIL_SERVER_PORT`: [SECRET]
* `EMAIL_SERVER_USER`: [SECRET]
* `GOOGLE_API_CREDENTIALS`: [SECRET]
* `JWT_SECRET`: [SECRET]
* `NEXT_PUBLIC_APP_URL`: `https://${YOUR_DOMAIN}`
* `NEXT_PUBLIC_BASE_URL`: `https://${YOUR_DOMAIN}`
* `NEXT_PUBLIC_EMBED_LIB_URL`: `https://${YOUR_DOMAIN}/embed/embed.js`
* `NEXT_PUBLIC_LICENSE_CONSENT`: `agree`
* `NEXT_PUBLIC_WEBAPP_URL`: `https://${YOUR_DOMAIN}`
* `NEXT_PUBLIC_WEBSITE_URL`: `https://${YOUR_DOMAIN}`
* `NEXT_TELEMETRY_DISABLED`: `1`
* `NEXTAUTH_SECRET`: [SECRET]
* `NEXTAUTH_URL`: `https://${YOUR_DOMAIN}`
* `NODE_ENV`: `production`
* `NPM_CONFIG_PRODUCTION`: `true`
* `PRIVACY_POLICY`: [TO_DEFINE] _(format of an URL)_
* `TERMS`: [TO_DEFINE] _(format of an URL)_
* `WEBSITE_URL`: `https://${YOUR_DOMAIN}`

### GitHub interface

#### GitHub Actions

Configure the following repository secrets (not environment ones):

- `CLEVER_APP_ID_PRODUCTION`: [GENERATED] _(format `app_{uuid}`, can be retrieved into the Clever Cloud interface)_
- `CLEVER_APP_ID_STAGING`: [GENERATED] _(format `app_{uuid}`, can be retrieved into the Clever Cloud interface)_
- `CLEVER_TOKEN`: [GENERATED] _(can be retrieved from `clever login`, but be warned it gives wide access)_
- `CLEVER_SECRET`: [GENERATED] _(can be retrieved from `clever login`, but be warned it gives wide access)_

## Upgrade cal.com version

1. Synchronize your fork with the original repository
2. Search for the specific commit representing the wanted version
3. Rebase your `deploy` or `deploy-staging` branches to it while making sure to not take third-party files into `.github`
4. Force-push the branch
