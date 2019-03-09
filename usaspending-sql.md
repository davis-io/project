## `transaction` schema

```
CREATE TABLE `transaction` (
  `award_id` REAL,
  `id` REAL,
  `is_fpds` INTEGER,
  `transaction_unique_id` TEXT,
  `generated_unique_award_id` TEXT,
  `usaspending_unique_transaction_id` TEXT,
  `type` TEXT,
  `type_description` TEXT,
  `period_of_performance_start_date` REAL,
  `period_of_performance_current_end_date` REAL,
  `action_date` REAL,
  `action_type` TEXT,
  `action_type_description` TEXT,
  `federal_action_obligation` REAL,
  `modification_number` TEXT,
  `description` TEXT,
  `drv_award_transaction_usaspend` TEXT,
  `drv_current_total_award_value_amount_adjustment` TEXT,
  `drv_potential_total_award_value_amount_adjustment` TEXT,
  `last_modified_date` REAL,
  `certified_date` REAL,
  `create_date` REAL,
  `update_date` REAL,
  `fiscal_year` INTEGER,
  `awarding_agency_id` INTEGER,
  `funding_agency_id` INTEGER,
  `place_of_performance_id` REAL,
  `recipient_id` REAL,
  `original_loan_subsidy_cost` REAL,
  `face_value_loan_guarantee` REAL,
  `funding_amount` REAL,
  `non_federal_funding_amount` REAL
);
```

## `agency` schema:

```
CREATE TABLE `agency` (
  `toptier_agency_id` INTEGER,
  `create_date` REAL,
  `update_date` REAL,
  `cgac_code` TEXT,
  `fpds_code` TEXT,
  `abbreviation` TEXT,
  `name` TEXT,
  `mission` TEXT,
  `website` TEXT,
  `icon_filename` TEXT
);
```

## `recipient` schema:

```
CREATE TABLE `recipient` (
  `id` INTEGER,
  `recipient_hash` TEXT,
  `legal_business_name` TEXT,
  `duns` TEXT,
  `address_line_1` TEXT,
  `address_line_2` TEXT,
  `business_types_codes` TEXT,
  `city` TEXT,
  `congressional_district` TEXT,
  `country_code` TEXT,
  `parent_duns` TEXT,
  `parent_legal_business_name` TEXT,
  `state` TEXT,
  `zip4` TEXT,
  `zip5` TEXT
);
```
## Extracting HHS data of California:
```
SELECT * FROM `transaction` INNER JOIN recipient ON `transaction`.id = recipient.id 
  WHERE (`transaction`.awarding_agency_id = 68 OR `transaction`.funding_agency_id = 68)
    AND recipient.state = 'CA'
```
