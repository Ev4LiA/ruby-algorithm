class Solution:
    def solution(self, S: str, T: str) -> int:
        N = len(S)

        if N == 1:
            return 0 if S == T else -1

        s_digits = [int(d) for d in S]
        t_digits = [int(d) for d in T]

        total_moves = 0

        for i in range(N - 1):
            if s_digits[i] == t_digits[i]:
                continue

            moves_at_i = (t_digits[i] - s_digits[i] + 10) % 10

            total_moves += moves_at_i

            s_digits[i] = t_digits[i]
            s_digits[i + 1] = (s_digits[i + 1] + moves_at_i) % 10

        if s_digits[N-1] == t_digits[N-1]:
            return total_moves
        else:
            return -1
