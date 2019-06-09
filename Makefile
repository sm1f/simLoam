SRC_DIR:=src
DBG_OBJ_DIR:=debug_obj
DBG_APP_DIR:=debug_app
PRD_OBJ_DIR:=obj
PRD_APP_DIR:=app

SRC_HEADERS=$(wildcard $(SRC_DIR)/*.h)

SRC_ALL:= $(wildcard $(SRC_DIR)/*.cpp)
SRC_MAINS:= $(wildcard $(SRC_DIR)/*Main.cpp)
SRC_NON_MAINS:= $(filter-out $(SRC_MAINS), $(SRC_ALL))

DBG_OBJ_ALL:=  $(patsubst $(SRC_DIR)/%.cpp,$(DBG_OBJ_DIR)/%.o,$(SRC_ALL))
PRD_OBJ_ALL:=  $(patsubst $(SRC_DIR)/%.cpp,$(PRD_OBJ_DIR)/%.o,$(SRC_ALL))

DBG_OBJ_MAINS:=  $(patsubst $(SRC_DIR)/%Main.cpp,$(DBG_OBJ_DIR)/%Main.o,$(SRC_MAINS))
PRD_OBJ_MAINS:=  $(patsubst $(SRC_DIR)/%Main.cpp,$(PRD_OBJ_DIR)/%Main.o,$(SRC_MAINS))

DBG_OBJ_NON_MAINS:= $(filter-out $(DBG_OBJ_MAINS), $(DBG_OBJ_ALL))
PRD_OBJ_NON_MAINS:= $(filter-out $(PRD_OBJ_MAINS), $(PRD_OBJ_ALL))


DBG_APP_ALL:= $(SRC_MAINS:$(SRC_DIR)/%-Main.cpp=$(DBG_APP_DIR)/%.exe)
PRD_APP_ALL:= $(SRC_MAINS:$(SRC_DIR)/%-Main.cpp=$(PRD_APP_DIR)/%.exe)

all: DBG_all PRD_all


DBG_all: MK_DBG_OBJ_DIR MK_DBG_APP_DIR $(DBG_OBJ_ALL) $(DBG_APP_ALL)
PRD_all: MK_PRD_OBJ_DIR MK_PRD_APP_DIR $(PRD_OBJ_ALL) $(PRD_APP_ALL)

MK_DBG_OBJ_DIR:
	@mkdir -p $(DBG_OBJ_DIR)
MK_PRD_OBJ_DIR:
	@mkdir -p $(PRD_OBJ_DIR)
MK_DBG_APP_DIR:
	@mkdir -p $(DBG_APP_DIR)
MK_PRD_APP_DIR:
	@mkdir -p $(PRD_APP_DIR)


DEPS=$(SOURCES:.cpp=.d)

CFLAGS+=-MMD

CXXFLAGS+= -Wno-unused-parameter -Wall  -g -O2 -MMD -Wno-unused-variable -std=c++14 \
	-DHAVE_CONFIG_H -I. -I../. -D_GNU_SOURCE  \
        -DIB_USE_STD_STRING -Wextra \
	-MD -MP

$(DBG_OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | MK_DBG_OBJ_DIR
	g++ $(CXXFLAGS) -DDEBUG -c -o $@ $<
$(PRD_OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | MK_PRD_OBJ_DIR
	g++ $(CXXFLAGS) -c -o $@ $<

$(DBG_APP_DIR)/%.exe: $(DBG_OBJ_ALL) | MK_DBG_APP_DIR
	g++ -Wall -Wextra -g -O2 -o $@ $(DBG_OBJ_NON_MAINS) $(@:$(DBG_APP_DIR)/%.exe=$(DBG_OBJ_DIR)/%-Main.o)
$(PRD_APP_DIR)/%.exe: $(PRD_OBJ_ALL) | MK_DBG_APP_DIR
	g++ -Wall -Wextra -g -O2 -o $@ $(PRD_OBJ_NON_MAINS) $(@:$(PRD_APP_DIR)/%.exe=$(PRD_OBJ_DIR)/%-Main.o)


.PRECIOUS: $(DBG_OBJ_DIR)/%.o
.PRECIOUS: $(PRD_OBJ_DIR)/%.o

.PHONY: clean
clean: DBG_clean PRD_clean
DBG_clean:
	rm -f $(DEPS) $(DBG_OBJ_DIR)/*.d $(DBG_OBJ_DIR)/*.o $(DBG_APP_DIR)/*
	rmdir --ignore-fail-on-non-empty $(DBG_OBJ_DIR) $(DBG_APP_DIR)
PRD_clean:
	rm -f $(DEPS) $(PRD_OBJ_DIR)/*.d $(PRD_OBJ_DIR)/*.o $(PRD_APP_DIR)/*
	rmdir --ignore-fail-on-non-empty $(PRD_OBJ_DIR) $(PRD_APP_DIR)

.PHONY: cleanForGit
cleanForGit: clean
	rm -f $(SRC_DIR)/*~

printVars:
	$(info DBG_APP_ALL $(DBG_APP_ALL))
	$(info SRC_MAINS $(SRC_MAINS))
	$(info SRC_DIR $(SRC_DIR))

hack:
	$(info SRC_DIR $(SRC_DIR))
	$(info DBG_OBJ_DIR $(DBG_OBJ_DIR))
	$(info DBG_APP_DIR $(DBG_APP_DIR))
	$(info SRC_ALL $(SRC_ALL))
	$(info SRC_MAINS $(SRC_MAINS))
	$(info SRC_NON_MAINS $(SRC_NON_MAINS))
	$(info DBG_OBJ_ALL $(DBG_OBJ_ALL))
	$(info DBG_OBJ_MAINS $(DBG_OBJ_MAINS))
	$(info DBG_OBJ_NON_MAINS $(DBG_OBJ_NON_MAINS))


help:
	$(info make all)
	$(info -   default)
	$(info -   make all apps - currently not working correctly)
	$(info make clean)
	$(info -   remove obj and app dirs)
	$(info -   needs work)
	$(info make cleanForGit)
	$(info -   deletes generated directories)
	$(info make help)
	$(info -   prints this message)
-include $(DEPS)
