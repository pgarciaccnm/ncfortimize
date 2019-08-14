# NC Manage Salesforce App

The purpose of this project is to prove my skills and experience as an SF developer.

## Understanding the Business Model

<strong>National Commercial business</strong>
NC manages and leasing properties.

Rep manages many Properties.<br>
Each property has many Units.<br>
The Rep leases the Units based on the Unit day cost.<br>
The commission earned by Rep is based on Graduated Commission model.<br>
The GC is associated with a period of time (year), Property Goal Amounts and has many tiers which define to the Rep performance.<br>
The Property Goal Amount is the goal must be reached by Rep in the period of GC.<br>
Some units have a Bounty for a period of time. The Bounty will be added to the Rep commission is it's applicable.

## ERD
<img src="https://github.com/pgarciaccnm/ncfortimize/blob/ncv2/ERD_NCFORTIMIZE.png" >

## Assumssions
Each Unit must be managed by one Rep in a period of GC.<br>
The period of leasing is the same that the GC associated.<br>


## TODO
Add the Bounty to the Rep commission. The Bounty table and relationship is completed.<br>
Develop the Rest Resource.<br>
Develop the Unit Test for more scenarios.<br>
Develop Reports.

