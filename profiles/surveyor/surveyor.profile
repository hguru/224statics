<?php

/**
 * Implements form_alter for the configuration form
 */
function surveyor_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];

  // Remove default country since it doesn't do anything. :P
  $form['server_settings']['site_default_country']['#access'] = FALSE;
}

/**
 * Preprocess the install page variables to add our logo.
 */
function surveyor_process_maintenance_page(&$variables) {
  $variables['logo'] = drupal_get_path('profile', 'surveyor') . '/logo.png';
}

/**
 * Implements hook_install_tasks().
 */
function surveyor_install_tasks(&$install_state) {
  $tasks['survyor_webformcom_import_form'] = array(
    'display_name' => st('Configure import'),
    'type' => 'form',
  );

  $tasks['survyor_webformcom_import_batch'] = array(
    'display_name' => st('Run import'),
    'type' => 'batch',
    // TODO: This conditional doesn't work, instead it's checked inside the
    // survyor_webformcom_import_batch() callback function.
    //'run' => empty($install_state['webformcom_import_file']) ? INSTALL_TASK_SKIP : INSTALL_TASK_RUN_IF_NOT_COMPLETED,
  );

  return $tasks;
}

/**
 * Installer task callback.
 */
function survyor_webformcom_import_form($form, &$form_state) {
  form_load_include($form_state, 'inc', 'webformcom_import', 'includes/webformcom_import.pages');
  $form['help'] = array(
    '#markup' => t('You can import data from Webform.com into your site. If you don\'t have an import file or you want to run it later, you may do so after install at:<br /> <strong>Site Configuration &rarr; Web Services &rarr; Webform.com Import</strong>.') . '</p>',
  );
  $form['webformcom_import'] = array(
    '#title' => t('Run Webform.com import?'),
    '#type' => 'radios',
    '#options' => array(
      0 => t('No thanks, I\'ll import later'),
      1 => t('Run import now'),
    ),
    '#default_value' => 0,
  );
  $form['webformcom_import_detect'] = array(
    '#theme_wrappers' => array('form_element'),
    '#markup' => t('Place your export .zip file in your site root. Any file with the name "webformcom_export_[number].zip" will be detected imported in the next step.'),
    '#states' => array(
      'visible' => array(
        ':input[name=webformcom_import]' => array('value' => (string) '1'),
      ),
    ),
  );
  $form['actions'] = array(
    '#type' => 'actions',
  );
  $form['actions']['submit'] = array(
    '#type' => 'submit',
    '#value' => t('Continue'),
  );
  return $form;
}

/**
 * Validate handler for survyor_webformcom_import_form().
 */
function survyor_webformcom_import_form_validate($form, &$form_state) {
  $form_state['values']['webformcom_import_file'] = webformcom_import_detect_export_zip();
  if ($form_state['values']['webformcom_import'] && !$form_state['values']['webformcom_import_file']) {
    form_error($form['webformcom_import'], t('An import file could not be found in your site directory. Place the file directly in the root of your Drupal installation, with the name "webformcom_export_[number].zip" (where [number] will be a number).'));
  }
}

/**
 * Submit handler for survyor_webformcom_import_form().
 */
function survyor_webformcom_import_form_submit($form, &$form_state) {
  // TODO: Kind of janky way to get $install_state. Is there a better way?
  $install_state = &$form_state['build_info']['args'][0];

  if ($form_state['values']['webformcom_import']) {
    $install_state['webformcom_import_file'] = $form_state['values']['webformcom_import_file'];
  }
}

/**
 * Installer task callback.
 */
function survyor_webformcom_import_batch($install_state) {
  // TODO: The "run" parameter in surveyor_install_tasks() should be able to
  // skip this callback for us.
  if (empty($install_state['webformcom_import_file'])) {
    return array();
  }

  module_load_include('inc', 'webformcom_import', 'includes/webformcom_import.pages');

  $settings = array(
    'file' => $install_state['webformcom_import_file'],
  );
  return webformcom_import_batch($settings);
}

