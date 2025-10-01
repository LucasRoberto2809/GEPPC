#include "utilitarios.h"

int int_random(int min, int max) {
	return (random() % (max - min + 1)) + min;
}

double float_random(int len, int min, int max) {
	double random_num = (double)(random() % (max - min + 1)) + min;
	int i=0, div=10.0;
	for (i=0; i<len; i++) {
		random_num += (double)(random() % 9) / div;
		div *= 10.0;
	}
	return random_num;
}

Command *make_command_node(NodeType type, Parameters parameters) {
	Command *node = malloc(sizeof(Command));
	node->type = type;
	node->next_command = NULL;
	node->parameter = parameters;
	return node;
}

Command *link_command(Command *current_command, Command *next_command) {
	current_command->next_command = next_command;
	return current_command;
}

void run_command(Command *command) {
	if (command == NULL) {
		return;
	}
	run_command(command->next_command);
	switch(command->type) {
		case NodeInt:
			printf("%d\n", int_random(command->parameter.min, command->parameter.max));
			break;
		case NodeFloat:
			printf("%.*f\n", command->parameter.decimal, float_random(command->parameter.decimal, command->parameter.min, command->parameter.max));
			break;
		case NodeArray:
			if (command->parameter.basic_type == BasicTypeInt) {
				for (int i=0; i<command->parameter.rows; i++) {
					for (int j=0; j<command->parameter.collumns-1; j++) {
						printf("%d ", int_random(command->parameter.min, command->parameter.max));
					}
					printf("%d\n", int_random(command->parameter.min, command->parameter.max));
				}
			}
			else if (command->parameter.basic_type == BasicTypeFloat) {
				for (int i=0; i<command->parameter.rows; i++) {
					for (int j=0; j<command->parameter.collumns-1; j++) {
						printf("%.*f ", command->parameter.decimal, float_random(command->parameter.decimal, command->parameter.min, command->parameter.max));
					}
					printf("%.*f\n", command->parameter.decimal, float_random(command->parameter.decimal, command->parameter.min, command->parameter.max));
				}
			}
			else {
				printf("Basic type not found\n");
			}
			break;
	}
}

void clear_commands(Command *current_command) {
	if (current_command == NULL) {
		return;
	}
	clear_commands(current_command->next_command);
	free(current_command);
}
