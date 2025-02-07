/* functions.c: ENCM 369 Winter 2025 Lab 3 Exercise C */

/* INSTRUCTIONS:
 *   You are to write a RARS translation of this C program.  Because
 *   this is the first assembly language program you are writing where you
 *   must deal with register conflicts and manage the stack, there are
 *   a lot of hints given in C comments about how to do the translation.
 *   In future lab exercises and on midterms, you will be expected
 *   to do this kind of translation without being given very many hints!
 */

/* Hint: Function prototypes, such as the next two lines of C,
 * are used by a C compiler to do type checking and sometimes type
 * conversions in function calls.  They do NOT cause ANY assembly
 * language code to be generated.
 */

int funcA(int first, int second, int third, int fourth);

int funcB(int y, int z);

int banana = 0x20000;

int main(void)
{
  /* Hint: This is a nonleaf function, so it needs a stack frame. */

  /* Instruction: Normally you could pick whatever two s-registers you
   * like for apple and orange, but in this exercise you must use s0
   * for apple and s1 for orange.
   */
  int apple;
  int orange;
  apple = 0x700;
  orange = 0x800;
  orange += funcA(5, 4, 3, 2);
  banana += (apple - orange);

  /* At this point banana should have a value of 0x1fc77. */

  return 0;
}

int funcA(int first, int second, int third, int fourth)
{
  /* Hint: This is a nonleaf function, so it needs a stack frame,
   * and you will have to make copies of the incoming arguments so
   * that a-registers are free for outgoing arguments. */

  /* Instructions: Normally you would have a lot of freedom within the
   * calling conventions about what s-registers you use, and about where
   * you put copies of incoming arguments, but in this exercise you
   * must copy first to s0, second to s1, third to s2, and fourth to s3, 
   * and use s4 for car, s5 for truck, and s6 for bus.
   */
  int car;
  int truck;
  int bus;
  car = funcB(fourth, third);
  bus = funcB(second, first);
  truck = funcB(third, fourth);

  return car + truck + bus;
}

int funcB(int y, int z)
{
  /* Hint: this is a leaf function, and it shouldn't need to use any
   * s-registers, so you should not have use the stack at all. */
  return y + z * 64;
}
