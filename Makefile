BASE = base
DOCKER = docker
JENKINS = jenkins
KUBERNETES = kubernetes kubernetes-aws
MINICONDA = miniconda
GIT = git
.PHONY: all info $(BASE) $(DOCKER) $(JENKINS) $(KUBERNETES) $(MINICONDA) $(GIT)

all: info

info:
	@echo "BASE: $(BASE)"
	@echo "DOCKER: $(DOCKER)"
	@echo "JENKINS $(JENKINS)"
	@echo "KUBERNETES: $(KUBERNETES)"
	@echo "MINICONDA: $(MINICONDA)"
	@echo "GIT: $(GIT)"

# BASE
base:
	@bash ./scripts/base.sh

# DOCKER
docker:
	@bash ./scripts/docker.sh

# JENKINS
jenkins:
	@bash ./scripts/jenkins.sh

# KUBERNETES
kubernetes:
	@bash ./scripts/kubernetes/kubernetes.sh
kubernetes-aws:
	@bash ./scripts/kubernetes/aws/kubernetes.sh

# MINICONDA
MINICONDA:
	@bash ./scripts/miniconda.sh

# GIT
git:
	@bash ./scripts/git.sh
	