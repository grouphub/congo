0. Set up environment
  - `brew install aws-elasticbeanstalk`
  - `chmod og-r ~/.ssh/grouphub-congo`

1. Configuration
  - `eb init`
    a. choose `us-east-1`
    b. select `congo`
    c. select `congo-staging` (change later with e.g., `eb use congo-production`)

2. Deployment
  - `eb deploy`