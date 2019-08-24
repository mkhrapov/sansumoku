//
//  monte_carlo_tree_search.c
//  Sansumoku
//
//  Created by Maksim Khrapov on 5/4/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "monte_carlo_tree_search.h"

#define OPEN 0
#define BLUE 1
#define ORAN 2
#define DONE 3

int calc_legal_moves(board_state *, int *);
int calc_smart_moves(board_state *, int *, int, int *);
int is_smart_move(board_state *, int);
void set(board_state *, int);
int playout(board_state *);
int is_terminal(board_state *);
int random_int(int);
int legal_move(board_state *, int);
int own_section(int);
int target_section(int);
int won(board_state *, int, int);
int entire_game_won_by(board_state *, int);
int entire_board_is_full(board_state *);
int full(board_state *, int);
int no_allowed_cells(board_state *);
int sudokuConstrained(board_state *, int);
int active(board_state *, int);
void pretty_print(float *);
void recursive_constraint_processing(board_state *);




int section_locations[9][9] = {
    { 0,  1,  2,  9, 10, 11, 18, 19, 20},
    { 3,  4,  5, 12, 13, 14, 21, 22, 23},
    { 6,  7,  8, 15, 16, 17, 24, 25, 26},
    {27, 28, 29, 36, 37, 38, 45, 46, 47},
    {30, 31, 32, 39, 40, 41, 48, 49, 50},
    {33, 34, 35, 42, 43, 44, 51, 52, 53},
    {54, 55, 56, 63, 64, 65, 72, 73, 74},
    {57, 58, 59, 66, 67, 68, 75, 76, 77},
    {60, 61, 62, 69, 70, 71, 78, 79, 80}
};

int list_of_indexes[8][3] = {
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},
    {0, 4, 8},
    {2, 4, 6}
};

int peers[81][16] = {
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 18, 27, 36, 45, 54, 63, 72},
    {0, 2, 3, 4, 5, 6, 7, 8, 10, 19, 28, 37, 46, 55, 64, 73},
    {0, 1, 3, 4, 5, 6, 7, 8, 11, 20, 29, 38, 47, 56, 65, 74},
    {0, 1, 2, 4, 5, 6, 7, 8, 12, 21, 30, 39, 48, 57, 66, 75},
    {0, 1, 2, 3, 5, 6, 7, 8, 13, 22, 31, 40, 49, 58, 67, 76},
    {0, 1, 2, 3, 4, 6, 7, 8, 14, 23, 32, 41, 50, 59, 68, 77},
    {0, 1, 2, 3, 4, 5, 7, 8, 15, 24, 33, 42, 51, 60, 69, 78},
    {0, 1, 2, 3, 4, 5, 6, 8, 16, 25, 34, 43, 52, 61, 70, 79},
    {0, 1, 2, 3, 4, 5, 6, 7, 17, 26, 35, 44, 53, 62, 71, 80},
    {0, 10, 11, 12, 13, 14, 15, 16, 17, 18, 27, 36, 45, 54, 63, 72},
    {1, 9, 11, 12, 13, 14, 15, 16, 17, 19, 28, 37, 46, 55, 64, 73},
    {2, 9, 10, 12, 13, 14, 15, 16, 17, 20, 29, 38, 47, 56, 65, 74},
    {3, 9, 10, 11, 13, 14, 15, 16, 17, 21, 30, 39, 48, 57, 66, 75},
    {4, 9, 10, 11, 12, 14, 15, 16, 17, 22, 31, 40, 49, 58, 67, 76},
    {5, 9, 10, 11, 12, 13, 15, 16, 17, 23, 32, 41, 50, 59, 68, 77},
    {6, 9, 10, 11, 12, 13, 14, 16, 17, 24, 33, 42, 51, 60, 69, 78},
    {7, 9, 10, 11, 12, 13, 14, 15, 17, 25, 34, 43, 52, 61, 70, 79},
    {8, 9, 10, 11, 12, 13, 14, 15, 16, 26, 35, 44, 53, 62, 71, 80},
    {0, 9, 19, 20, 21, 22, 23, 24, 25, 26, 27, 36, 45, 54, 63, 72},
    {1, 10, 18, 20, 21, 22, 23, 24, 25, 26, 28, 37, 46, 55, 64, 73},
    {2, 11, 18, 19, 21, 22, 23, 24, 25, 26, 29, 38, 47, 56, 65, 74},
    {3, 12, 18, 19, 20, 22, 23, 24, 25, 26, 30, 39, 48, 57, 66, 75},
    {4, 13, 18, 19, 20, 21, 23, 24, 25, 26, 31, 40, 49, 58, 67, 76},
    {5, 14, 18, 19, 20, 21, 22, 24, 25, 26, 32, 41, 50, 59, 68, 77},
    {6, 15, 18, 19, 20, 21, 22, 23, 25, 26, 33, 42, 51, 60, 69, 78},
    {7, 16, 18, 19, 20, 21, 22, 23, 24, 26, 34, 43, 52, 61, 70, 79},
    {8, 17, 18, 19, 20, 21, 22, 23, 24, 25, 35, 44, 53, 62, 71, 80},
    {0, 9, 18, 28, 29, 30, 31, 32, 33, 34, 35, 36, 45, 54, 63, 72},
    {1, 10, 19, 27, 29, 30, 31, 32, 33, 34, 35, 37, 46, 55, 64, 73},
    {2, 11, 20, 27, 28, 30, 31, 32, 33, 34, 35, 38, 47, 56, 65, 74},
    {3, 12, 21, 27, 28, 29, 31, 32, 33, 34, 35, 39, 48, 57, 66, 75},
    {4, 13, 22, 27, 28, 29, 30, 32, 33, 34, 35, 40, 49, 58, 67, 76},
    {5, 14, 23, 27, 28, 29, 30, 31, 33, 34, 35, 41, 50, 59, 68, 77},
    {6, 15, 24, 27, 28, 29, 30, 31, 32, 34, 35, 42, 51, 60, 69, 78},
    {7, 16, 25, 27, 28, 29, 30, 31, 32, 33, 35, 43, 52, 61, 70, 79},
    {8, 17, 26, 27, 28, 29, 30, 31, 32, 33, 34, 44, 53, 62, 71, 80},
    {0, 9, 18, 27, 37, 38, 39, 40, 41, 42, 43, 44, 45, 54, 63, 72},
    {1, 10, 19, 28, 36, 38, 39, 40, 41, 42, 43, 44, 46, 55, 64, 73},
    {2, 11, 20, 29, 36, 37, 39, 40, 41, 42, 43, 44, 47, 56, 65, 74},
    {3, 12, 21, 30, 36, 37, 38, 40, 41, 42, 43, 44, 48, 57, 66, 75},
    {4, 13, 22, 31, 36, 37, 38, 39, 41, 42, 43, 44, 49, 58, 67, 76},
    {5, 14, 23, 32, 36, 37, 38, 39, 40, 42, 43, 44, 50, 59, 68, 77},
    {6, 15, 24, 33, 36, 37, 38, 39, 40, 41, 43, 44, 51, 60, 69, 78},
    {7, 16, 25, 34, 36, 37, 38, 39, 40, 41, 42, 44, 52, 61, 70, 79},
    {8, 17, 26, 35, 36, 37, 38, 39, 40, 41, 42, 43, 53, 62, 71, 80},
    {0, 9, 18, 27, 36, 46, 47, 48, 49, 50, 51, 52, 53, 54, 63, 72},
    {1, 10, 19, 28, 37, 45, 47, 48, 49, 50, 51, 52, 53, 55, 64, 73},
    {2, 11, 20, 29, 38, 45, 46, 48, 49, 50, 51, 52, 53, 56, 65, 74},
    {3, 12, 21, 30, 39, 45, 46, 47, 49, 50, 51, 52, 53, 57, 66, 75},
    {4, 13, 22, 31, 40, 45, 46, 47, 48, 50, 51, 52, 53, 58, 67, 76},
    {5, 14, 23, 32, 41, 45, 46, 47, 48, 49, 51, 52, 53, 59, 68, 77},
    {6, 15, 24, 33, 42, 45, 46, 47, 48, 49, 50, 52, 53, 60, 69, 78},
    {7, 16, 25, 34, 43, 45, 46, 47, 48, 49, 50, 51, 53, 61, 70, 79},
    {8, 17, 26, 35, 44, 45, 46, 47, 48, 49, 50, 51, 52, 62, 71, 80},
    {0, 9, 18, 27, 36, 45, 55, 56, 57, 58, 59, 60, 61, 62, 63, 72},
    {1, 10, 19, 28, 37, 46, 54, 56, 57, 58, 59, 60, 61, 62, 64, 73},
    {2, 11, 20, 29, 38, 47, 54, 55, 57, 58, 59, 60, 61, 62, 65, 74},
    {3, 12, 21, 30, 39, 48, 54, 55, 56, 58, 59, 60, 61, 62, 66, 75},
    {4, 13, 22, 31, 40, 49, 54, 55, 56, 57, 59, 60, 61, 62, 67, 76},
    {5, 14, 23, 32, 41, 50, 54, 55, 56, 57, 58, 60, 61, 62, 68, 77},
    {6, 15, 24, 33, 42, 51, 54, 55, 56, 57, 58, 59, 61, 62, 69, 78},
    {7, 16, 25, 34, 43, 52, 54, 55, 56, 57, 58, 59, 60, 62, 70, 79},
    {8, 17, 26, 35, 44, 53, 54, 55, 56, 57, 58, 59, 60, 61, 71, 80},
    {0, 9, 18, 27, 36, 45, 54, 64, 65, 66, 67, 68, 69, 70, 71, 72},
    {1, 10, 19, 28, 37, 46, 55, 63, 65, 66, 67, 68, 69, 70, 71, 73},
    {2, 11, 20, 29, 38, 47, 56, 63, 64, 66, 67, 68, 69, 70, 71, 74},
    {3, 12, 21, 30, 39, 48, 57, 63, 64, 65, 67, 68, 69, 70, 71, 75},
    {4, 13, 22, 31, 40, 49, 58, 63, 64, 65, 66, 68, 69, 70, 71, 76},
    {5, 14, 23, 32, 41, 50, 59, 63, 64, 65, 66, 67, 69, 70, 71, 77},
    {6, 15, 24, 33, 42, 51, 60, 63, 64, 65, 66, 67, 68, 70, 71, 78},
    {7, 16, 25, 34, 43, 52, 61, 63, 64, 65, 66, 67, 68, 69, 71, 79},
    {8, 17, 26, 35, 44, 53, 62, 63, 64, 65, 66, 67, 68, 69, 70, 80},
    {0, 9, 18, 27, 36, 45, 54, 63, 73, 74, 75, 76, 77, 78, 79, 80},
    {1, 10, 19, 28, 37, 46, 55, 64, 72, 74, 75, 76, 77, 78, 79, 80},
    {2, 11, 20, 29, 38, 47, 56, 65, 72, 73, 75, 76, 77, 78, 79, 80},
    {3, 12, 21, 30, 39, 48, 57, 66, 72, 73, 74, 76, 77, 78, 79, 80},
    {4, 13, 22, 31, 40, 49, 58, 67, 72, 73, 74, 75, 77, 78, 79, 80},
    {5, 14, 23, 32, 41, 50, 59, 68, 72, 73, 74, 75, 76, 78, 79, 80},
    {6, 15, 24, 33, 42, 51, 60, 69, 72, 73, 74, 75, 76, 77, 79, 80},
    {7, 16, 25, 34, 43, 52, 61, 70, 72, 73, 74, 75, 76, 77, 78, 80},
    {8, 17, 26, 35, 44, 53, 62, 71, 72, 73, 74, 75, 76, 77, 78, 79}
};





int monte_carlo_tree_search(int iter_count, board_state *bs) {
    float scores[81];
    int legal_move_count;
    int legal_moves[81];
    int winner;
    int smart_move_count; // smart move is a move that does not immediately result in opponent win
    int smart_moves[81];
    board_state child;
    
    for(int i = 0; i < 81; i++) {
        scores[i] = 0.0;
        legal_moves[i] = -1;
    }
    
    legal_move_count = calc_legal_moves(bs, legal_moves);
    
    /*
     check for dumb moves
     if all moves are dumb - pick ramdom move from all legal moves
     if only one move not dumb - use that
     if two or moves are not dumb - run Monte Carlo Tree Search to pick among those
     */
    
    smart_move_count = calc_smart_moves(bs, legal_moves, legal_move_count, smart_moves);
    
    if(smart_move_count == 0) {
        return legal_moves[random_int(legal_move_count)];
    }
    else if(smart_move_count == 1) {
        return smart_moves[0];
    }
    
    // else pick from two or more smart moves
   
    for(int counter = 0; counter < iter_count; counter++) {
        for(int move_idx = 0; move_idx < smart_move_count; move_idx++) {
            int move = smart_moves[move_idx];
            memcpy(&child, bs, sizeof(board_state));
            set(&child, move);
            winner = playout(&child);
            if (winner == bs->player) {
                scores[move] += 1.0;
            }
            else if (winner == DONE) {
                scores[move] += 0.05;
            }
        }
        
        /*
        if((counter+1) % 100 == 0) {
            printf("%d\n", counter + 1);
            pretty_print(scores);
        }
         */
    }
    
    float max = 0.0;
    int winning_move = 0;
    
    for(int i = 0; i < 81; i++) {
        if (scores[i] > max) {
            winning_move = i;
            max = scores[i];
        }
    }
    
    return winning_move;
}


int calc_smart_moves(board_state *bs, int *legal_moves, int legal_move_count, int *smart_moves) {
    int counter = 0;
    
    for(int move_idx = 0; move_idx < legal_move_count; move_idx++) {
        int move = legal_moves[move_idx];
        if(is_smart_move(bs, move) == 1) {
            smart_moves[counter] = move;
            counter++;
        }
    }
    
    return counter;
}


int is_smart_move(board_state *bs, int move) {
    board_state current;
    board_state child;
    memcpy(&current, bs, sizeof(board_state));
    set(&current, move);
    int opponent = current.player;
    if(is_terminal(&current) == 1) {
        return 1;
    }
    
    int legal_move_count;
    int legal_moves[81];
    
    for(int i = 0; i < 81; i++) {
        legal_moves[i] = -1;
    }
    
    legal_move_count = calc_legal_moves(&current, legal_moves);
    
    for(int move_idx = 0; move_idx < legal_move_count; move_idx++) {
        int child_move = legal_moves[move_idx];
        memcpy(&child, &current, sizeof(board_state));
        set(&child, child_move);
        if(is_terminal(&child) == 1 && child.gameWon == opponent) {
            return 0;
        }
    }
    
    return 1;
}


/* legal_moves is an array of 81 ints */
int calc_legal_moves(board_state *bs, int *legal_moves) {
    int counter = 0;
    for(int i = 0; i < 81; i++) {
        if(legal_move(bs, i)) {
            legal_moves[counter] = i;
            counter++;
        }
    }
    return counter;
}


void set(board_state *bs, int move) {
    if(legal_move(bs, move) == 0) {
        return;
    }
    
    int current_section = own_section(move);
    
    bs->cellOccupied[move] = bs->player;
    bs->cellValue[move] = bs->sectionNextValue[current_section];
    bs->sectionNextValue[current_section] += 1;
    
    if(won(bs, bs->player, current_section)) {
        bs->sectionWon[current_section] = bs->player;
        if(entire_game_won_by(bs, bs->player)) {
            bs->gameWon = bs->player;
        }
        else if(entire_board_is_full(bs)) {
            bs->gameWon = DONE;
        }
    }
    else if(full(bs, current_section)) {
        bs->sectionWon[current_section] = DONE;
        if(entire_board_is_full(bs)) {
            bs->gameWon = DONE;
        }
    }
    
    /* zero out allowed cells and sections */
    for(int i = 0; i < 9; i++) {
        bs->sectionAllowed[i] = 0;
    }
    
    for(int i = 0; i < 81; i++) {
        bs->cellAllowed[i] = 0;
    }
    
    /* figure out allowed sections */
    int next_section = target_section(move);
    if(bs->sectionWon[next_section] == OPEN) {
        bs->sectionAllowed[next_section] = 1;
    }
    else {
        for(int i = 0; i < 9; i++) {
            if(bs->sectionWon[i] == OPEN) {
                bs->sectionAllowed[i] = 1;
            }
        }
    }
    
    /* figure out allowed cells */
    for(int sec = 0; sec < 9; sec++) {
        if(bs->sectionAllowed[sec] == 1) {
            for(int cell_idx = 0; cell_idx < 9; cell_idx++) {
                int cell = section_locations[sec][cell_idx];
                if(bs->cellOccupied[cell] == OPEN && !sudokuConstrained(bs, cell)) {
                    bs->cellAllowed[cell] = 1;
                }
            }
        }
    }
    
    recursive_constraint_processing(bs);
    
    /* finishing touches */
    if(bs->player == BLUE) {
        bs->player = ORAN;
    }
    else {
        bs->player = BLUE;
    }
}


void recursive_constraint_processing(board_state *bs) {
    if(is_terminal(bs)) {
        return;
    }
    
    if(!no_allowed_cells(bs)) {
        return;
    }
    
    /*
     opponent can not make a play, all cells in allowed sections are either
     occupied or prohibited by sudoku constraints. We break this deadend
     by scoring the allowed sections for the player, and allowing opponent
     to play in any non-won, non-full sections.
     */
    
    for(int sec = 0; sec < 9; sec++) {
        if(bs->sectionAllowed[sec] == 1) {
            bs->sectionWon[sec] = bs->player;
        }
    }
    
    if(entire_game_won_by(bs, bs->player)) {
        bs->gameWon = bs->player;
    }
    else if(entire_board_is_full(bs)) {
        bs->gameWon = DONE;
    }
    else {
        /* zero out allowed cells and sections */
        for(int i = 0; i < 9; i++) {
            bs->sectionAllowed[i] = 0;
        }
        
        for(int i = 0; i < 81; i++) {
            bs->cellAllowed[i] = 0;
        }
        
        /* figure out allowed sections */
        for(int i = 0; i < 9; i++) {
            if(bs->sectionWon[i] == OPEN) {
                bs->sectionAllowed[i] = 1;
            }
        }
        
        /* figure out allowed cells */
        for(int sec = 0; sec < 9; sec++) {
            if(bs->sectionAllowed[sec] == 1) {
                for(int cell_idx = 0; cell_idx < 9; cell_idx++) {
                    int cell = section_locations[sec][cell_idx];
                    if(bs->cellOccupied[cell] == OPEN && !sudokuConstrained(bs, cell)) {
                        bs->cellAllowed[cell] = 1;
                    }
                }
            }
        }
    }
    
    recursive_constraint_processing(bs);
}


int playout(board_state *bs) {
    int legal_move_count;
    int legal_moves[81];
    
    while(!is_terminal(bs)) {
        for(int i = 0; i < 81; i++) {
            legal_moves[i] = -1;
        }
        
        legal_move_count = calc_legal_moves(bs, legal_moves);
        if(legal_move_count == 0) {
            printf("ERROR: game state is not terminal, but there are no legal moves.\n");
            break;
        }
        set(bs, legal_moves[random_int(legal_move_count)]);
    }
    
    return bs->gameWon;
}


int is_terminal(board_state *bs) {
    if(bs->gameWon != OPEN) {
        return 1;
    }
    return 0;
}


int random_int(int limit) {
    static int been_called = 0;
    
    if(been_called == 0) {
        been_called = 1;
        srand((unsigned int)time(NULL));
    }
    
    return rand() % limit;
}


int legal_move(board_state *bs, int move) {
    if(bs->gameWon != OPEN) {
        return 0;
    }
    
    if(move > 80) {
        return 0;
    }
    
    if(move < 0) {
        return 0;
    }
    
    return bs->cellAllowed[move];
}


int own_section(int move) {
    int y = move / 9;
    int x = move % 9;
    return 3*(y/3) + (x/3);
}


int target_section(int move) {
    int y = move / 9;
    int x = move % 9;
    return 3*(y%3) + (x%3);
}


int won(board_state *bs, int player, int sec) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int relative_position1 = list_of_indexes[row][0];
        int relative_position2 = list_of_indexes[row][1];
        int relative_position3 = list_of_indexes[row][2];
        
        int actual_position1 = section_locations[sec][relative_position1];
        int actual_position2 = section_locations[sec][relative_position2];
        int actual_position3 = section_locations[sec][relative_position3];
        
        if(
            bs->cellOccupied[actual_position1] == player &&
            bs->cellOccupied[actual_position2] == player &&
            bs->cellOccupied[actual_position3] == player
        ) {
            return 1;
        }
    }
    
    return 0;
}


int entire_game_won_by(board_state *bs, int player) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int sec1 = list_of_indexes[row][0];
        int sec2 = list_of_indexes[row][1];
        int sec3 = list_of_indexes[row][2];
        
        if(
            bs->sectionWon[sec1] == player &&
            bs->sectionWon[sec2] == player &&
            bs->sectionWon[sec3] == player
            ) {
                return 1;
            }
    }
    
    return 0;
}


int entire_board_is_full(board_state *bs) {
    for(int sec = 0; sec < 9; sec++) {
        if(bs->sectionWon[sec] == OPEN) {
            return 0;
        }
    }
    return 1;
}


int full(board_state *bs, int sec) {
    for(int i = 0; i < 9; i++) {
        int location = section_locations[sec][i];
        if(bs->cellOccupied[location] == OPEN) {
            return 0;
        }
    }
    return 1;
}


int no_allowed_cells(board_state *bs) {
    for(int i = 0; i < 81; i++) {
        if(bs->cellAllowed[i] == 1) {
            return 0;
        }
    }
    return 1;
}


int sudokuConstrained(board_state *bs, int cell) {
    int section = own_section(cell);
    int digit = bs->sectionNextValue[section];
    
    for(int i = 0; i < 16; i++) {
        int location = peers[cell][i];
        if(active(bs, location)) {
            if(bs->cellValue[location] == digit) {
                return 1;
            }
        }
    }
    return 0;
}


int active(board_state *bs, int location) {
    int sec = own_section(location);
    if(bs->sectionWon[sec] == BLUE || bs->sectionWon[sec] == ORAN) {
        return 0;
    }
    return 1;
}


void pretty_print(float *scores) {
    for(int y = 0; y < 9; y++) {
        for(int x = 0; x < 9; x++) {
            int i = y*9 + x;
            
            printf("%10.2f", scores[i]);
        }
        printf("\n");
    }
    printf("\n\n\n");
}
