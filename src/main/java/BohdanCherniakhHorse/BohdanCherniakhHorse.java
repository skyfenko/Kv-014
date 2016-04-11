package BohdanCherniakhHorse;

public class BohdanCherniakhHorse {
    public static int[][] compute(int[][] board) {
        // using board
        // return [[0,0], [1,2], ... ]
        HorsePathProcessor horcePath = new HorsePathProcessor(board);
        return horcePath.getPath();
    }
}