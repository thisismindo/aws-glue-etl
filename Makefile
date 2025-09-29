TERRAFORM = terraform

init:
	$(TERRAFORM) -chdir=platform init

plan: init
	$(TERRAFORM) -chdir=platform plan -out=aws-glue-tf

deploy || update: init
	$(TERRAFORM) -chdir=platform apply aws-glue-tf

delete: init
	$(TERRAFORM) -chdir=platform destroy

refresh: init
	$(TERRAFORM) -chdir=platform refresh

show: init
	$(TERRAFORM) -chdir=platform show aws-glue-tf

output:
	$(TERRAFORM) -chdir=platform output

console:
	$(TERRAFORM) -chdir=platform console
