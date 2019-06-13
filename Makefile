CXX = g++
CXXFLAGS = -Wall -Wextra -Wpedantic -g -std=c++17

SRCDIR := src
SRCS := $(wildcard $(SRCDIR)/*.cpp)
HPPS := $(wildcard $(SRCDIR)/*.hpp)
OBJDIR := obj
OBJS := $(addprefix $(OBJDIR)/,$(notdir $(SRCS:.cpp=.o)))
BINDIR := bin

LD=g++
#LD_LIBS=-lboost_system -lboost_filesystem -pthread -lz -lprotobuf-lite -losmpbf

#OSMFILEPARSER_LIB := lib/OsmFileParser/lib/libosmfileparser.a

#ASTYLE := astyle
#ASTYLE_FLAGS := --options=astyle.cfg

DEPDIR := dep
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

COMPILE.cpp = $(CXX) $(DEPFLAGS) $(CXXFLAGS) -c
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

all :
	#$(MAKE) -C lib/OsmFileParser 
	#$(MAKE) astyle
	$(MAKE) $(BINDIR)/ptpphcshm

$(BINDIR)/ptpphcshm : $(OBJS) | $(BINDIR)
	$(LD) $(LDFLAGS) -o $@ $^ $(LD_LIBS)
	
$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
$(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(DEPDIR)/%.d | $(OBJDIR) $(DEPDIR)
	$(COMPILE.cpp) $< -o $@
	$(POSTCOMPILE)

$(OBJDIR) :
	mkdir -p $(OBJDIR)

$(DEPDIR) :
	mkdir -p $(DEPDIR)

$(BINDIR) :
	mkdir -p $(BINDIR)

clean :
	rm -f $(OBJS) $(BINDIR)/ptpphcshm

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

-include $(patsubst %,$(DEPDIR)/%.d,$(notdir $(basename $(SRCS))))
