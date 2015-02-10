require 'pokitdok'

class Api::V1::EligibilitiesController < ApplicationController
  def create
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first

    carrier_account_id = params[:carrier_account_id]
    carrier_account = CarrierAccount
      .where(id: carrier_account_id, account_id: account.id)
      .includes(:carrier)
      .first

    carrier = carrier_account.carrier

    member_id = params[:member_id]
    date_of_birth = params[:date_of_birth]
    first_name = params[:first_name]
    last_name = params[:last_name]

    # pokitdok = PokitDok::PokitDok.new \
    #   Rails.application.config.pokitdok.client_id,
    #   Rails.application.config.pokitdok.client_secret

    # # Eligibility
    # eligibility_query = {
    #   member: {
    #       birth_date: '1970-01-01',
    #       first_name: 'Jane',
    #       last_name: 'Doe',
    #       id: 'W000000000'
    #   },
    #   provider: {
    #       first_name: 'JEROME', # or organization_name
    #       last_name: 'AYA-AY',
    #       npi: '1467560003'
    #   },
    #   service_types: ['health_benefit_plan_coverage'],
    #   trading_partner_id: 'MOCKPAYER'
    # }

    # # Eligibility
    # eligibility_query = {
    #   member: {
    #       birth_date: date_of_birth,
    #       first_name: first_name,
    #       last_name: last_name,
    #       id: member_id
    #   },
    #   provider: {
    #       organization_name: carrier.organization_name,
    #       first_name: carrier.first_name,
    #       last_name: carrier.last_name,
    #       npi: carrier.npi
    #   },
    #   service_types: carrier.service_types,
    #   trading_partner_id: carrier.trading_partner_id
    # }

    # eligibility = pokitdok.eligibility(eligibility_query)

    eligibility = {
      meta: {
        rate_limit_amount: 1,
        rate_limit_reset: 1423477157,
        application_mode: 'production',
        processing_time: 568,
        rate_limit_cap: 1000,
        credits_remaining: 999,
        activity_id: '54d87b95fba8eb1366621632',
        credits_billed: 1
      },
      data: {
        service_types: [
          'professional_physician_visit_office'
        ],
        client_id: 'ZzzUk4r9DMbV0F9xfuxG',
        payer: {
          id: 'MOCKPAYER',
          name: 'MOCK PAYER INC'
        },
        summary: {
          deductible: {
            individual: {
              in_network: {
                applied: {
                  currency: 'USD',
                  amount: '16.43'
                },
                limit: {
                  currency: 'USD',
                  amount: '3000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '2983.57'
                }
              },
              out_of_network: {
                applied: {
                  currency: 'USD',
                  amount: '16.43'
                },
                limit: {
                  currency: 'USD',
                  amount: '6000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '5983.57'
                }
              }
            },
            family: {
              in_network: {
                applied: {
                  currency: 'USD',
                  amount: '43.91'
                },
                limit: {
                  currency: 'USD',
                  amount: '6000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '5956.09'
                }
              },
              out_of_network: {
                applied: {
                  currency: 'USD',
                  amount: '43.91'
                },
                limit: {
                  currency: 'USD',
                  amount: '12000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '11956.09'
                }
              }
            }
          },
          out_of_pocket: {
            individual: {
              in_network: {
                applied: {
                  currency: 'USD',
                  amount: '16.43'
                },
                limit: {
                  currency: 'USD',
                  amount: '3000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '2983.57'
                }
              },
              out_of_network: {
                applied: {
                  currency: 'USD',
                  amount: '16.43'
                },
                limit: {
                  currency: 'USD',
                  amount: '12500'
                },
                remaining: {
                  currency: 'USD',
                  amount: '12483.57'
                }
              }
            },
            family: {
              in_network: {
                applied: {
                  currency: 'USD',
                  amount: '43.91'
                },
                limit: {
                  currency: 'USD',
                  amount: '6000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '5956.09'
                }
              },
              out_of_network: {
                applied: {
                  currency: 'USD',
                  amount: '43.91'
                },
                limit: {
                  currency: 'USD',
                  amount: '25000'
                },
                remaining: {
                  currency: 'USD',
                  amount: '24956.09'
                }
              }
            }
          }
        },
        subscriber: {
          first_name: 'Jane',
          last_name: 'Doe',
          gender: 'male',
          address: {
            city: 'SPARTANBURG',
            state: 'SC',
            zipcode: '29307',
            address_lines: [
              '123 MAIN ST'
            ]
          },
          birth_date: '1970-01-01',
          id: 'W000000000'
        },
        correlation_id: '88daa36c-fc62-45f5-b2b1-6c5dcce652b9',
        trading_partner_id: 'MOCKPAYER',
        provider: {
          first_name: 'JEROME',
          last_name: 'JEROME AYA-AY',
          npi: '1467560003'
        },
        coverage: {
          plan_number: '0888188',
          service_types: [
            'professional_physician_visit_office'
          ],
          group_number: '088818801000013',
          out_of_pocket: [
            {
              in_plan_network: 'yes',
              benefit_amount: {
                currency: 'USD',
                amount: '3000'
              },
              coverage_level: 'individual',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'yes',
              benefit_amount: {
                currency: 'USD',
                amount: '2983.57'
              },
              coverage_level: 'individual',
              time_period: 'remaining',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'yes',
              benefit_amount: {
                currency: 'USD',
                amount: '6000'
              },
              coverage_level: 'family',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'yes',
              benefit_amount: {
                currency: 'USD',
                amount: '5956.09'
              },
              coverage_level: 'family',
              time_period: 'remaining',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'no',
              benefit_amount: {
                currency: 'USD',
                amount: '12500'
              },
              coverage_level: 'individual',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'no',
              benefit_amount: {
                currency: 'USD',
                amount: '12483.57'
              },
              coverage_level: 'individual',
              time_period: 'remaining',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              in_plan_network: 'no',
              benefit_amount: {
                currency: 'USD',
                amount: '25000'
              },
              coverage_level: 'family',
              service_types: [
                'health_benefit_plan_coverage'
              ]
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'Unlimited Lifetime Benefits'
                }
              ],
              in_plan_network: 'no',
              time_period: 'remaining',
              coverage_level: 'family',
              benefit_amount: {
                currency: 'USD',
                amount: '24956.09'
              }
            }
          ],
          insurance_type: 'ppo',
          level: 'employee_and_spouse',
          copay: [
            {
              in_plan_network: 'yes',
              service_types: [
                'professional_physician_visit_office'
              ],
              coverage_level: 'employee_and_spouse',
              messages: [
                {
                  message: 'PRIMARY OFFICE'
                }
              ],
              copayment: {
                currency: 'USD',
                amount: '0'
              }
            },
            {
              in_plan_network: 'not_applicable',
              service_types: [
                'professional_physician_visit_office'
              ],
              coverage_level: 'employee_and_spouse',
              messages: [
                {
                  message: 'GYN OFFICE VS'
                },
                {
                  message: 'GYN VISIT'
                },
                {
                  message: 'SPEC OFFICE'
                },
                {
                  message: 'SPEC VISIT'
                },
                {
                  message: 'PRIME CARE VST'
                },
                {
                  message: 'Plan Requires PreCert'
                },
                {
                  message: 'Commercial'
                },
                {
                  message: 'Plan includes NAP'
                },
                {
                  message: 'Pre-Existing may apply'
                }
              ],
              copayment: {
                currency: 'USD',
                amount: '0'
              }
            }
          ],
          plan_description: 'Open Choice',
          deductibles: [
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX,GYN OFFICE VS,DED INCLUDED IN OOP,GYN VISIT,SPEC OFFICE,SPEC VISIT,PRIMARY OFFICE,PRIME CARE VST'
                }
              ],
              in_plan_network: 'yes',
              eligibility_date: '2013-01-01',
              time_period: 'calendar_year',
              coverage_level: 'family',
              benefit_amount: {
                currency: 'USD',
                amount: '6000'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX'
                }
              ],
              in_plan_network: 'yes',
              time_period: 'remaining',
              coverage_level: 'family',
              benefit_amount: {
                currency: 'USD',
                amount: '5956.09'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX,GYN OFFICE VS,DED INCLUDED IN OOP,GYN VISIT,SPEC OFFICE,SPEC VISIT,PRIMARY OFFICE,PRIME CARE VST'
                }
              ],
              in_plan_network: 'yes',
              eligibility_date: '2013-01-01',
              time_period: 'calendar_year',
              coverage_level: 'individual',
              benefit_amount: {
                currency: 'USD',
                amount: '3000'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX'
                }
              ],
              in_plan_network: 'yes',
              time_period: 'remaining',
              coverage_level: 'individual',
              benefit_amount: {
                currency: 'USD',
                amount: '2983.57'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX,GYN OFFICE VS,DED INCLUDED IN OOP,GYN VISIT,SPEC OFFICE,SPEC VISIT,PRIME CARE VST'
                }
              ],
              in_plan_network: 'no',
              eligibility_date: '2013-01-01',
              time_period: 'calendar_year',
              coverage_level: 'family',
              benefit_amount: {
                currency: 'USD',
                amount: '12000'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX'
                }
              ],
              in_plan_network: 'no',
              time_period: 'remaining',
              coverage_level: 'family',
              benefit_amount: {
                currency: 'USD',
                amount: '11956.09'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX,GYN OFFICE VS,DED INCLUDED IN OOP,GYN VISIT,SPEC OFFICE,SPEC VISIT,PRIME CARE VST'
                }
              ],
              in_plan_network: 'no',
              eligibility_date: '2013-01-01',
              time_period: 'calendar_year',
              coverage_level: 'individual',
              benefit_amount: {
                currency: 'USD',
                amount: '6000'
              }
            },
            {
              service_types: [
                'health_benefit_plan_coverage'
              ],
              messages: [
                {
                  message: 'INT MED AND RX'
                }
              ],
              in_plan_network: 'no',
              time_period: 'remaining',
              coverage_level: 'individual',
              benefit_amount: {
                currency: 'USD',
                amount: '5983.57'
              }
            }
          ],
          plan_begin_date: '2013-02-15',
          eligibility_begin_date: '2012-02-01',
          active: true,
          coinsurance: [
            {
              benefit_percent: 0.0,
              service_types: [
                'professional_physician_visit_office'
              ],
              coverage_level: 'employee_and_spouse',
              messages: [
                {
                  message: 'GYN OFFICE VS'
                },
                {
                  message: 'GYN VISIT'
                },
                {
                  message: 'SPEC OFFICE'
                },
                {
                  message: 'SPEC VISIT'
                },
                {
                  message: 'PRIMARY OFFICE'
                },
                {
                  message: 'PRIME CARE VST'
                }
              ],
              in_plan_network: 'yes'
            },
            {
              benefit_percent: 0.5,
              service_types: [
                'professional_physician_visit_office'
              ],
              coverage_level: 'employee_and_spouse',
              messages: [
                {
                  message: 'GYN OFFICE VS,COINS APPLIES TO OUT OF POCKET'
                },
                {
                  message: 'GYN VISIT,COINS APPLIES TO OUT OF POCKET'
                },
                {
                  message: 'SPEC OFFICE,COINS APPLIES TO OUT OF POCKET'
                },
                {
                  message: 'SPEC VISIT,COINS APPLIES TO OUT OF POCKET'
                },
                {
                  message: 'PRIME CARE VST,COINS APPLIES TO OUT OF POCKET'
                }
              ],
              in_plan_network: 'no'
            }
          ],
          group_description: 'MOCK INDIVIDUAL ADVANTAGE PLAN',
          service_date: '2013-08-10'
        },
        valid_request: true
      }
    }

    # SSN
    # Member Name
    # Member Date of Birth
    # Member Zip Code
    # Member Sex
    # Health Insurance ID
    # Plan Name
    # Plan Number
    # Rx IIN/BIN

    respond_to do |format|
      format.json {
        render json: {
          eligibility: JSON.pretty_generate(eligibility)
        }
      }
    end
  end
end

