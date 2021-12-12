#include <stdio.h>
#include <stdlib.h>

typedef struct Packet {
    float weight;
    int cost;
} Packet;

int get_cost(float weight);
int get_post_income(int array[], int length);
float get_most_heavy(float weights[], int length);
Packet* get_empty_packet_array(int length);
void sort_packets(Packet* packets, int length);

int main()
{
    float weights[] = {28.f, 5.5f, 32.f, 4.5f, 7.3f, 15.3f, 1.5f, 3.6f, 12.4f, 6.5f, 5.5f};
    const int packets_length = sizeof(weights) / sizeof(float);

    int prices[packets_length];
    for (int i = 0; i < packets_length; i++){
        prices[i] = get_cost(weights[i]);
    }

    int postal_income = get_post_income(prices, packets_length);
    printf("A posta bevetele %dFt volt.\n", postal_income);

    float heaviest = get_most_heavy(weights, packets_length);
    printf("A legnehezebb csomag %.1fkg volt.\n", heaviest);

    Packet* packets = get_empty_packet_array(packets_length);
    for (int i = 0; i < packets_length; i++){
        Packet pack = {weights[i], prices[i]};
        packets[i] = pack;
    }

    sort_packets(packets, packets_length);
    printf("Csomagok: \n");
    for (int i = 0; i < packets_length; i++){
        printf("%d. %.1fkg, %dft\n", i, packets[i].weight, packets[i].cost);
    }

    return 0;
}

int get_cost(float weight){
    if (weight <= 2.f){
        return 1630;
    }
    else if (weight <= 5.f ){
        return 1850;
    }
    else if (weight <= 10.f ){
        return 1960;
    }
    else if (weight <= 20.f ){
        return 2180;
    }
    return 0;
}

int get_post_income(int array[], int length){
    int sum = 0;
    for (int i = 0; i < length; i++){
        sum += array[i];
    }
    return sum;
}

float get_most_heavy(float* weights, int length){
    float max = 0.f;
    for (int i = 0; i < length; i++){
        if (max < weights[i]){
            max = weights[i];
        }
    }
    return max;
}

Packet* get_empty_packet_array(int length){
    return malloc(sizeof(Packet) * length);
}

void sort_packets(Packet* packets, int length){
    for (int i = 0; i < length; i++){
        int min_index = i;
        float min = packets[i].weight;
        for (int j = i + 1; j < length; j++){
            if (packets[j].weight < min){
                min_index = j;
                min = packets[j].weight;
            }
        }
        if (min_index != i){
            Packet temp = packets[i];
            packets[i] = packets[min_index];
            packets[min_index] = temp;
        }
    }
}
