import java.util.ArrayList;

public class Minesweeper {

    public static final int NUM_ROWS = 5;
    public static final int NUM_COLS = 5;
    public static final int NUM_MINES = 5;

    private MSButton[][] buttons;
    private ArrayList<MSButton> mines;

    public Minesweeper() {

        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        mines = new ArrayList<MSButton>();

        for (int r = 0; r < NUM_ROWS; r++) {
            for (int c = 0; c < NUM_COLS; c++) {
                buttons[r][c] = new MSButton(r, c);
            }
        }

        setMines();
    }

    public void setMines() {
        while (mines.size() < NUM_MINES) {
            int r = (int)(Math.random() * NUM_ROWS);
            int c = (int)(Math.random() * NUM_COLS);

            if (!mines.contains(buttons[r][c])) {
                mines.add(buttons[r][c]);
            }
        }
    }

    public boolean isValid(int row, int col) {
        return row >= 0 && row < NUM_ROWS &&
               col >= 0 && col < NUM_COLS;
    }

    public int countMines(int row, int col) {

        int count = 0;

        for (int r = row - 1; r <= row + 1; r++) {
            for (int c = col - 1; c <= col + 1; c++) {

                if (isValid(r, c)) {
                    if (mines.contains(buttons[r][c])) {
                        count++;
                    }
                }

            }
        }

        return count;
    }

    public boolean isWon() {

        for (int r = 0; r < NUM_ROWS; r++) {
            for (int c = 0; c < NUM_COLS; c++) {

                if (!mines.contains(buttons[r][c]) &&
                    !buttons[r][c].clicked) {
                    return false;
                }

            }
        }

        return true;
    }

    public void displayWinMessage() {
        for (int r = 0; r < NUM_ROWS; r++) {
            for (int c = 0; c < NUM_COLS; c++) {
                buttons[r][c].label = "WIN";
            }
        }
    }

    public void displayLosingMessage() {
        for (MSButton b : mines) {
            b.label = "X";
        }
    }

    public class MSButton {

        int row, col;
        boolean clicked;
        boolean flagged;
        String label;

        public MSButton(int r, int c) {
            row = r;
            col = c;
            clicked = false;
            flagged = false;
            label = "";
        }

        public void mousePressed(boolean rightClick) {

            if (rightClick) {
                flagged = !flagged;
                if (!flagged) {
                    clicked = false;
                }
                return;
            }

            clicked = true;

            if (mines.contains(this)) {
                displayLosingMessage();
                return;
            }

            int num = countMines(row, col);

            if (num > 0) {
                label = "" + num;
            } else {

                // recursive clearing
                for (int r = row - 1; r <= row + 1; r++) {
                    for (int c = col - 1; c <= col + 1; c++) {

                        if (isValid(r, c) && !buttons[r][c].clicked) {
                            buttons[r][c].mousePressed(false);
                        }

                    }
                }

            }

            if (isWon()) {
                displayWinMessage();
            }
        }
    }
}
