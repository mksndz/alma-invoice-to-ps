# Alma/PeopleSoft Integration - Account Payable

## Overview

Parses the output of Alma's [Invoice Export](https://developers.exlibrisgroup.com/alma/integrations/finance/invoice-export) ([XML format definition](https://developers.exlibrisgroup.com/alma/apis/xsd/invoice_payment.xsd)), converts to PeopleSoft XML, and transmits to SOAP endpoint.

## Usage
 
`ruby run.rb`

### Details

- Script pulls latest Alma export from a specified local directory (see [FileHandler](https://github.com/GIL-GALILEO/alma-invoice-to-ps/blob/master/lib/objects/file_handler.rb))
- To use, a few config files will need to be created with your data:
    1. `secrets.yml` - holding sensitive information
        - `endpoint_url` url for SOAP endpoint
        - `s_user` user for submission auth
        - `s_pass` pass for submission auth
        - `owner_myid` for record attribution in PS
        - `slack_webhook_url` for slack notifications
    2. `chartstrings.yml` - define chartstrings for use in PS XML
        - TODO: add template file
    3. `defaults.yml` for default values in PS XML
        - TODO: add template file
- You will probably also need to modify the [PS XML template file](https://github.com/GIL-GALILEO/alma-invoice-to-ps/blob/master/lib/templates/ps.xml.erb) to meet your requirements.

Configuration for Alma XML Invoice export can be found in Integration Profiles -> Check Requests -> Actions -> Export Invoices for Payment 

© 2018 University of Georgia