#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct FloatParametros{
	int decimal;
	int min;
	int max;
};

struct IntParametros{
	int min;
	int max;
};

int int_random(int min, int max);
double float_random(int len, int min, int max);

// Implementation of a command list with pointers for types


typedef struct Command Command;
typedef struct Parameters Parameters;

Command *make_command_node();
Command *link_command();
void run_command();
void clear_commands();

typedef enum {
	BasicTypeInt,
	BasicTypeFloat,
} BasicType;

typedef enum {
	NodeInt,
	NodeFloat,
	NodeArray,
} NodeType;

struct Parameters {
	BasicType basic_type;
	int min;
	int max;
	int decimal;
	int rows;
	int collumns;
};

struct Command {
	NodeType type;
	Command *next_command;
	Parameters parameter;
};
