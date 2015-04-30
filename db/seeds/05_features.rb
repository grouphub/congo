Feature.create! \
  name: 'eligibility_modal',
  description: 'Allow certain broker accounts to check eligibility.',
  enabled_for_all: false,
  account_slugs: %w[first_account]

Feature.create! \
  name: 'api_tokens',
  description: 'Allow certain broker accounts to access our API.',
  enabled_for_all: false,
  account_slugs: %w[first_account]

Feature.create! \
  name: 'spreadsheet_import',
  description: 'Allow certain broker accounts to import employee data from spreadsheet.',
  enabled_for_all: false,
  account_slugs: %w[spreadsheet_import]

