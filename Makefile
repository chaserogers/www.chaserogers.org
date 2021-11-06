#! /usr/bin/make -f

www_distro_id = E33VQ9YG1NZC45
www_bucket_uri = s3://www.chaserogers.org
plan_file = crogers.plan

deploy_site: sync invalidate

sync:
	cd site && \
	aws s3 sync . ${www_bucket_uri}

invalidate:
	aws cloudfront create-invalidation --distribution-id ${www_distro_id} --paths '/*'

list_invalidations:
	aws cloudfront list-invalidations --distribution-id ${www_distro_id}

init:
	cd terraform && \
	terraform init --backend-config config/backend.tfvars

plan:
	cd terraform && \
	terraform plan --var-file config/default.tfvars --out ${plan_file}

apply:
	cd terraform && \
	terraform apply ${plan_file}
