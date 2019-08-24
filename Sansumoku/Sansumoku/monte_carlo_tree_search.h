//
//  monte_carlo_tree_search.h
//  Sansumoku
//
//  Created by Maksim Khrapov on 5/4/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

#ifndef monte_carlo_tree_search_h
#define monte_carlo_tree_search_h

#include <inttypes.h>

typedef struct board_state {
    int8_t cellOccupied[81];
    int8_t cellValue[81];
    int8_t cellAllowed[81];
    int8_t sectionWon[9];
    int8_t sectionAllowed[9];
    int8_t sectionNextValue[9];
    int8_t player;
    int8_t gameWon;
} board_state;


int monte_carlo_tree_search(int iter_count, board_state *);


#endif /* monte_carlo_tree_search_h */
