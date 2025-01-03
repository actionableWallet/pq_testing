#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include "dynamic.h"
#include <assert.h>

#define BLOCKSIZE 1024
#define FRAGSIZE 1220 

void init_partial_rr(PartialRR *prr) {
    prr->rrid = 0;
    prr->block_markers = NULL;
    prr->bytes = NULL;
    prr->rrsize = 0;
    prr->blocks_received = 0;
    prr->bytes_received = 0;
    prr->expected_blocks = 0;
    prr->is_complete = false;
}

void init_rr_frag(RRFrag *rrfrag) {
    rrfrag->name = NULL; 
    rrfrag->type = 0; 
    rrfrag->fragsize = 0;
    rrfrag->curidx = 0;
    rrfrag->rrsize = 0;
    rrfrag->rrid = 0;
    rrfrag->fragdata = NULL; 
}

void init_packed_rr(PackedRR *packed_rr) {
    packed_rr->isRRFrag = false;
    packed_rr->data.rrfrag = NULL; 
}

void init_partial_dns_message(PartialDNSMessage *pm) {
    sem_init(&pm->lock, 0, 1);
    pm->identification = 0;
    pm->identification_set = false;
    pm->flags = 0;
    pm->flags_set = false;
    pm->qdcount = 0;
    pm->qdcount_set = false;
    pm->ancount = 0;
    pm->ancount_set = false;
    pm->nscount = 0;
    pm->nscount_set = false;
    pm->arcount = 0;
    pm->arcount_set = false;
    pm->question_section = NULL; 
    pm->questions_done = 0;
    pm->answers_section = NULL; 
    pm->answers_done = 0;
    pm->authoritative_section = NULL; 
    pm->authoritative_done = 0;
    pm->additional_section = NULL; 
    pm->additionals_done = 0;
}

void send_packets(PartialDNSMessage *pm, PackedRR **msgsection, uint16_t sec_len) {
    clock_t start_time = clock();
    copy_section(pm, msgsection, sec_len);
    clock_t end_time = clock();
    double time_taken = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("%f ms\n", time_taken * 1000);
    
}

void fillData(unsigned char* fragdata) {
	for (int i = 0; i < FRAGSIZE; i++) {
		fragdata[i] = 'a';
	}
}

int main(int argc, char *argv[]) {
	if (argc != 3) {
        printf("\n\nIncorrect usage: ./arrf_[dynamic|static] <fragSize> <ddos>");
		exit(1);
    } 
    

	int fragSize = atoi(argv[1]);

    PartialDNSMessage pm = {
        .ancount = 1,
        .nscount = 0,
        .arcount = 0,
        .answers_section = malloc(sizeof(PartialRR*) * fragSize),
        .authoritative_section = NULL,
        .additional_section = NULL,
        .answers_done = 0,
        .authoritative_done = 0,
        .additionals_done = 0
    };
    if (!pm.answers_section) {
        printf("Error allocating answers_section\n");
        return -1;
    }

    pm.answers_section[0] = malloc(sizeof(PartialRR));
    if (!pm.answers_section[0]) {
        printf("Error allocating PartialRR\n");
        free(pm.answers_section);
        return -1;
    }
    memset(pm.answers_section[0], 0, sizeof(PartialRR));

    // Simulates UDP data
    unsigned char fragdata[FRAGSIZE];
    fillData(fragdata);


    PackedRR **msgsection = malloc(sizeof(PackedRR*) * fragSize);
	if (!msgsection) {
        printf("Error allocating msgsection\n");
        free(pm.answers_section[0]);
        free(pm.answers_section);
        return -1;
    }
    
	RRFrag *rrfrag = malloc(sizeof(RRFrag) * fragSize);
	if (!rrfrag) {
		printf("Error allocating\n");
		exit(1);
	}
    for (int i = 0; i < fragSize; i++) {
        // 1232 bytes worth of data simulating a UDP packet
        rrfrag[i] = (RRFrag){
            .rrid = 0,
            .curidx = i,
            .fragsize = fragSize,
            .rrsize = fragSize,
            .fragdata = fragdata
        };
	}
        
	msgsection[0] = &(PackedRR){
		.isRRFrag = true,
		.data.rrfrag = rrfrag
	};

    if (strcmp("./arrf_static", argv[0]) && strcmp("attack", argv[2])) {
        printf("Launching attack!\n");
        msgsection[0]->data.rrfrag->rrsize = INT32_MAX;
    }
    send_packets(&pm, msgsection, fragSize);
	
    free(rrfrag);
    free(msgsection);
    free(pm.answers_section[0]);
    free(pm.answers_section);
    return 0;
}


