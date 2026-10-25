#include <json-c/json.h>
#include <malloc.h>
#include <stdio.h>

static void generate_and_release(void)
{
    struct json_object *root = json_object_new_object();
    struct json_object *nodes = json_object_new_array();
    json_object_object_add(root, "nodes", nodes);
    for (int i = 0; i < 100; ++i) {
        struct json_object *node = json_object_new_object();
        json_object_object_add(node, "name", json_object_new_string("window"));
        json_object_array_add(nodes, node);
    }
    json_object_put(root);
}

int main(void)
{
    /* Warm up allocator caches before measuring live heap allocations. */
    for (int i = 0; i < 100; ++i)
        generate_and_release();
    size_t before = mallinfo2().uordblks;
    for (int i = 0; i < 2000; ++i)
        generate_and_release();
    size_t after = mallinfo2().uordblks;
    size_t growth = after > before ? after - before : 0;
    printf("Live heap growth after 2000 JSON releases: %zu bytes\n", growth);
    /* Allow allocator bookkeeping, but not retained JSON containers. */
    return growth > 1024 * 1024;
}
