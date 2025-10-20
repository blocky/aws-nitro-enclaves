# AWS Nitro Enclaves at Blocky

A repository for managing AWS Nitro Enclave dependencies at Blocky

## Build EIF

To reduce the overall dependencies required when building Nitro Enclave 
deployable images, we use nix to specify the building of the build-eif 
portion of the aws nitro enclave cli.
