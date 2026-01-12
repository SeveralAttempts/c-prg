#ifdef DYNAMIC_ARRAY_CORE_H
#define DYNAMIC_ARRAY_CORE_H

typedef struct {
    int* array;
    int capacity;
    int size;
} d_array;

d_array init_d_array(int size);
d_array init_d_array(int size, int capacity);
void free_d_array();

#endif // DYNAMIC_ARRAY_CORE_H

