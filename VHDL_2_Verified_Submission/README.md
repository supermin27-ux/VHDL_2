# VHDL 2 | 순차 논리회로 실습

다섯 회로의 VHDL 설계, 시뮬레이션 테스트벤치, 개별 게이트로 구성한 Logisim 프로젝트, 합성 및 시뮬레이션 보고서를 포함한다.

| 번호 | 회로 | Logisim 프로젝트 | VHDL 최상위 | 테스트벤치 |
| --- | --- | --- | --- | --- |
| 01 | RS Latch | `logisim/01_rs_latch.circ` | `rs_latch` | `tb_rs_latch` |
| 02 | D Latch | `logisim/02_d_latch.circ` | `d_latch` | `tb_d_latch` |
| 03 | D Flip-Flop | `logisim/03_d_flip_flop.circ` | `d_flip_flop` | `tb_d_flip_flop` |
| 04 | JK Flip-Flop | `logisim/04_jk_flip_flop.circ` | `jk_flip_flop` | `tb_jk_flip_flop` |
| 05 | D Flip-Flop with Async Set/Clear | `logisim/05_d_ff_async_set_clear.circ` | `d_ff_async_set_clear` | `tb_d_ff_async_set_clear` |

[VHDL_2_Report.pdf](VHDL_2_Report.pdf)에 Logisim 회로, GHDL 합성 회로도, VHDL 파형, 입력별 검증 결과를 담았다.

## Logisim-evolution

1. Logisim-evolution에서 해당 `.circ`를 연다. 검증에는 3.9.0을 사용했다.
2. 상단 툴바 왼쪽의 Poke Tool을 고르고 입력 사각형을 클릭해 0과 1을 바꾼다. Q는 오른쪽 출력 원 안의 숫자로 읽는다. CLK도 입력 사각형이며 0에서 1로 바꾸면 상승 에지가 생긴다.
3. 03번과 04번은 왼쪽 프로젝트 목록에서 `D_Latch_Cell`을 열어 내부 NAND 게이트를 볼 수 있다. 05번의 내부 게이트는 `Async_D_Latch_Cell`에서 확인한다.

| 회로 | 직접 확인할 입력 순서 |
| --- | --- |
| RS | `S,R`을 01 → 00 → 10 → 00 → 11 → 01 순서로 만든다. `Q,Q_N`은 01 → 01 → 10 → 10 → 00 → 01이다. 11에서 한 입력을 먼저 0으로 내려 복귀한다. |
| D Latch | `EN=1`에서 D를 0에서 1로 바꾸고 Q를 확인한다. 이어서 EN을 0으로 내린 다음 D를 0으로 바꿔도 Q는 1을 유지한다. |
| D FF | `CLK=0, D=1`에서 CLK를 1로 올리면 Q가 1이 된다. D를 0으로 바꾸고 CLK를 내려도 Q는 1이다. 다음 상승 에지에서 Q가 0이 된다. |
| JK FF | CLK를 0으로 둔 상태에서 `J,K=01`을 맞춘 뒤 상승 에지로 Q를 0으로 만든다. 이후 각 상승 에지 전에 10, 00, 11, 11, 01 순으로 입력을 설정하면 Q는 1, 1, 0, 1, 0이 된다. |
| Async D FF | CLK를 고정한 상태에서 SET을 1로 올리면 Q가 1이 된다. SET을 1로 둔 채 CLR을 1로 올리면 Q가 0이 된다. CLR만 0으로 내리면 Q가 다시 1이 된다. 두 제어를 모두 끄면 다음 상승 에지부터 D를 저장한다. |

## VHDL 시뮬레이션과 합성

저장소 루트에서 다음 예를 실행한다. 다른 회로는 표의 최상위 이름과 테스트벤치 이름을 사용한다. 테스트벤치는 VHDL-2008로 작성했으며 입력을 인가한 뒤 Q를 검사하고 성공 시 PASS를 출력한다.

```text
ghdl -a --std=08 vhdl/d_flip_flop.vhd testbench/tb_d_flip_flop.vhd
ghdl -e --std=08 tb_d_flip_flop
ghdl -r --std=08 tb_d_flip_flop --assert-level=error --vcd=d_flip_flop.vcd
ghdl synth --std=08 --latches --out=vhdl d_flip_flop
ghdl synth --std=08 --latches --out=dot d_flip_flop
```

`--latches`는 의도한 래치 추론을 허용한다. 합성은 DUT 최상위로 실행한다. RS 래치의 두 NOR 사이에는 상태를 저장하는 피드백이 있다. Logisim에서는 입력을 바꾼 뒤 전파가 안정된 값을 읽는다. D와 JK 입력은 CLK를 올리기 전에 설정한다.
