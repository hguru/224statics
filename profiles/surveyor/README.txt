Surveyor - Survey Building Distribution for Drupal
==================================================

Surveyor is a Drupal distribution that bundles together existing contributed
modules preconfigured to work together to build a site for hosting surveys.
This distribution is intended to be a jump-off point for building your own
customized installation of Drupal. It does not include any custom modules that
are not available elsewhere, it simply packages and configures several modules
to prepare them for use in collecting surveys. These modules include:

- Webform (drupal.org/project/webform)
- Form Builder (drupal.org/project/form_builder)
- CAPTCHA (drupal.org/project/captcha)
- MIME Mail (drupal.org/project/mimemail)
- Webform.com Import (drupal.org/project/webformcom_import)

During the installation process, you will be given an opportunity to import
Webform.com data into your own site. If you don't want to run the import as
part of the install (or don't have an import to run at all), you may skip that
step and do it later.

Installation
------------

It is recommended to follow the INSTALL.txt file in the root of the download
Drupal directory. This profile does not have any requirements that differ from
that of Drupal itself.

One caveat: During the installation, the CAPTCHA module will give you the
message "You can now configure the CAPTCHA module for your site.". However the
installation is not yet finished. DO NOT click the link to configure CAPTCHA.
That may be done after installation is finished. This bug in CAPCHA module is
being addressed in http://drupal.org/node/1983754.

Rebuilding Manually
-------------------

If this project is checked out from the Git code repository directly rather than
using the pre-built download link, you can manually build the entire project and
all the dependencies by using drush make:

drush make build-surveyor.make build

This will build the entire project into a "build" directory.

For more information on install profiles, see http://drupal.org/node/1022020.
