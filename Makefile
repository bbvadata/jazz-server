#  BBVA - Jazz: A lightweight analytical web server for data-driven applications.
#  ------------
#
#  Copyright 2016-2017 Banco Bilbao Vizcaya Argentaria, S.A.
#
# This product includes software developed at
#
#  BBVA (https://www.bbva.com/)
#
#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Target (0) : Help
# -----------------

help:
	@echo ""
	@echo "make [nothing],"
	@echo "make help           : Show this help."
	@echo ""
	@echo "  (Binaries: Make as a normal user, or clean the mess with: sudo make clean)"
	@echo ""
	@echo "make jazz           : Make the DEBUG Jazz executable."
	@echo "make rjazz          : Make the RELEASE Jazz executable."
	@echo "make tjazz          : Make the DEBUG&TEST Jazz executable."
	@echo ""
	@echo "  (Phony: Make as a normal user, or clean the mess with: sudo make clean)"
	@echo ""
	@echo "make clean          : Clean up all files not stored in the repo."
	@echo "make info           : Display the Jazz version, flags and important names and paths."
	@echo "make runtest        : Run all the tests on the DEBUG&TEST executable."

	@echo ""


# Variables:
# ----------

LINUX           := Ubuntu_16.10
HOME            := $(shell pwd)
LD_LIBRARY_PATH := $(HOME)/libs
VERSION         := $(shell cat src/jzzH/JazzVersion.h | head -1 | sed -e "s/\#define JAZZ_VERSION \"//" -e "s/\"//")
CXXFLAGS        := -std=c++11 -I$(HOME)

DFLAGS := -DDEBUG -g
RFLAGS := -DNDEBUG
TFLAGS := -DDEBUG -DCATCH_TEST -g

ifneq ("$(wildcard bin_debug)","")
	CPPFLAGS := $(DFLAGS)
endif

ifneq ("$(wildcard bin_release)","")
	CPPFLAGS := $(RFLAGS)
endif

ifneq ("$(wildcard bin_test)","")
	CPPFLAGS := $(TFLAGS)
endif

VPATH   = src/jzzALLOC src/jzzBLOCKS src/jzzCONFIG src/jzzH src/jzzHTTP src/jzzLOGGER src/jzzMAIN  \
          src/jzzMISCUTILS bin_debug bin_release bin_test

objects = jazzCommons.o jazzWebSource.o jzzALLOC.o jzzAPI.o jzzBLOCKCONV.o jzzBLOCKS.o jzzCONFIG.o \
          jzzHTTP.o jzzINSTANCES.o jzzLOGGER.o jzzMAIN.o jzzMISCUTILS.o


# Header file dependencies:
# -------------------------

jazzCommons.o:   jazzCommons.h
jazzWebSource.o: jazzWebSource.h jazzCommons.h jzzBLOCKS.h jzzINSTANCES.h
jzzALLOC.o:      jazzCommons.h
jzzAPI.o:        jzzAPI.h jazzCommons.h jazzWebSource.h jzzINSTANCES.h
jzzBLOCKCONV.o:  jzzBLOCKCONV.h jazzCommons.h jzzBLOCKS.h
jzzBLOCKS.o:     jzzBLOCKS.h jazzCommons.h
jzzCONFIG.o:     jazzCommons.h
jzzHTTP.o:       jazzCommons.h jazzWebSource.h
jzzINSTANCES.o:  jzzINSTANCES.h jazzCommons.h jzzBLOCKCONV.h
jzzLOGGER.o:     jazzCommons.h jzzBLOCKS.h
jzzMAIN.o:       jazzCommons.h jzzINSTANCES.h jzzAPI.h
jzzMISCUTILS.o:  jazzCommons.h


# Targets (1): Folders bin_debug, bin_release and bin_test
# ------------

bin_debug:
	@echo "Switching to DEBUG mode ..."
	@make clean
	@mkdir bin_debug
	$(eval CPPFLAGS = $(DFLAGS))

bin_release:
	@echo "Switching to RELEASE mode ..."
	@make clean
	@mkdir bin_release
	$(eval CPPFLAGS = $(RFLAGS))

bin_test:
	@echo "Switching to DEBUG&TEST mode ..."
	@make clean
	@mkdir bin_test
	$(eval CPPFLAGS = $(TFLAGS))


# Targets (2): Making the executable
# ------------

jazz: bin_debug $(objects)
	@echo "Making DEBUG Jazz ..."
	g++ -o bin_debug/jazz $(objects) -Ilibs -Llibs -lmicrohttpd -llmdb

rjazz: bin_release $(objects)
	@echo "Making RELEASE Jazz ..."
	g++ -o bin_release/rjazz $(objects) -Ilibs -Llibs -lmicrohttpd -llmdb

tjazz: bin_test $(objects)
	@echo "Making DEBUG&TEST Jazz ..."
	g++ -o bin_test/tjazz $(objects) -Ilibs -Llibs -lmicrohttpd -llmdb


# Targets (3): Phony targets
# ------------

.PHONY : clean
clean  :
	@echo "Cleaning up all files not stored in the repo ..."
	@cd $(HOME)
	@rm -f *.o
	@rm -rf bin_debug
	@rm -rf bin_release
	@rm -rf bin_test

.PHONY : info
info   :
	@echo "Current Jazz version        : $(VERSION)"
	@echo "Current Jazz home           : $(HOME)"
	@echo "Current Linux platform      : $(LINUX)"
	@echo "Current CPPFLAGS            : $(CPPFLAGS)"
	@echo "Current CXXFLAGS            : $(CXXFLAGS)"
	@echo "Current LD_LIBRARY_PATH     : $(LD_LIBRARY_PATH)"

.PHONY  : runtest
runtest : tjazz
	@echo "Running all the tests on DEBUG&TEST Jazz ..."
	@export LD_LIBRARY_PATH=$(HOME)/libs && ./bin_test/tjazz -sa
