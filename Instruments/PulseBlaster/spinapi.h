/* spinapi.h
 * API definitions for the spinapi library.
 *
  * $Date: 2008/04/28 18:29:51 $
 *
 * To get the latest version of this code, or to contact us for support, please
 * visit http://www.spincore.com
 */

/* Copyright (c) 2008 SpinCore Technologies, Inc.
 *
 * This software is provided 'as-is', without any express or implied warranty. 
 * In no event will the authors be held liable for any damages arising from the 
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose, 
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software in a
 * product, an acknowledgment in the product documentation would be appreciated
 * but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */


#ifndef _SPINAPI_H
#define _SPINAPI_H

//Defines for start_programming
#define PULSE_PROGRAM  0
#define FREQ_REGS      1

#define PHASE_REGS     2
#define TX_PHASE_REGS  2
#define PHASE_REGS_1   2

#define RX_PHASE_REGS  3
#define PHASE_REGS_0   3

// These are names used by RadioProcessor
#define COS_PHASE_REGS 51
#define SIN_PHASE_REGS 50

// For specifying which device in pb_dds_load
#define DEVICE_SHAPE 0x099000
#define DEVICE_DDS   0x099001

//Defines for enabling analog output
#define ANALOG_ON 1
#define ANALOG_OFF 0
#define TX_ANALOG_ON 1
#define TX_ANALOG_OFF 0
#define RX_ANALOG_ON 1
#define RX_ANALOG_OFF 0

//Defines for different pb_inst instruction types
#define CONTINUE 0
#define STOP 1
#define LOOP 2
#define END_LOOP 3
#define JSR 4
#define RTS 5
#define BRANCH 6
#define LONG_DELAY 7
#define WAIT 8

//Defines for using different units of time
#define ns 1.0
#define us 1000.0
#define ms 1000000.0
// This causes problems with some versions of stdio.h
//#define s 1000000000.0

//Defines for using different units of frequency
#define MHz 1.0
#define kHz .001
#define Hz .000001

#define PARAM_ERROR -99

//Variables for max number of registers (Currently the same across models) THIS NEEDS TO BE WEEDED OUT!!! any occurances should be replaced with board[cur_board].num_phase2, etc.
#define MAX_PHASE_REGS 16
#define MAX_FREQ_REGS 16

/// \brief Overflow counter structure
///
/// This structure holds the values of the various onboard overflow counters. These counters
/// stop counting once they reach 65535.
typedef struct {
    /// Number of overflows that occur when sampling data at the ADC
    int adc; 
    /// Number of overflows that occur after the CIC filter
    int cic;
    /// Number of overflows that occur after the FIR filter
    int fir;
    /// Number of overflows that occur during the averaging process
    int average;
} PB_OVERFLOW_STRUCT;

//if building windows dll, compile with -DDLL_EXPORTS flag
//if building code to use windows dll, no -D flag necessary
#ifdef WINDOWS
#ifdef DLL_EXPORTS
#define SPINCORE_API __declspec(dllexport)
#else
#define SPINCORE_API __declspec(dllimport)
#endif
// else if not on windows, SPINCORE_API does not mean anything
#else
#define SPINCORE_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

SPINCORE_API int pb_count_boards (void);
SPINCORE_API int pb_select_board (int board_num);
SPINCORE_API int pb_init(void);
SPINCORE_API void pb_set_clock(double clock_freq);
SPINCORE_API int pb_close(void);
SPINCORE_API int pb_start_programming(int device);
SPINCORE_API int pb_set_freq(double freq);
SPINCORE_API int pb_set_phase(double phase);
SPINCORE_API int pb_inst_tworf(int freq, int tx_phase, int tx_output_enable, int rx_phase, int rx_output_enable, int flags, int inst, int inst_data, double length);
SPINCORE_API int pb_inst_onerf(int freq, int phase, int rf_output_enable, int flags, int inst, int inst_data, double length);
SPINCORE_API int pb_inst_pbonly(int flags, int inst, int inst_data, double length);
SPINCORE_API int pb_inst_direct(int flags, int inst, int inst_data_direct, int length);
SPINCORE_API int pb_stop_programming(void);
SPINCORE_API int pb_start(void);
SPINCORE_API int pb_stop(void);
SPINCORE_API int pb_outp(unsigned int address, char data);
SPINCORE_API char pb_inp(unsigned int address);
SPINCORE_API int pb_outw(unsigned int address, unsigned int data);
SPINCORE_API unsigned int pb_inw(unsigned int address);
SPINCORE_API void pb_set_ISA_address(int address);
SPINCORE_API double pb_get_rounded_value(void);
SPINCORE_API int pb_read_status(void);
SPINCORE_API int pb_read_fullStat(int address);
SPINCORE_API char* pb_get_version(void);
SPINCORE_API char* pb_get_error(void);
SPINCORE_API int pb_get_firmware_id(void);
SPINCORE_API void pb_sleep_ms(int milliseconds);
SPINCORE_API void pb_set_debug(int debug);
SPINCORE_API void pb_bypass_FF_fix(int option);

// RadioProcessor related functions
SPINCORE_API int pb_set_defaults(void);
SPINCORE_API int pb_inst_radio(int freq, int cos_phase, int sin_phase, int tx_phase, int tx_enable, int phase_reset, int trigger_scan, int flags, int inst, int inst_data, double length);
SPINCORE_API int pb_inst_radio_shape(int freq, int cos_phase, int sin_phase, int tx_phase, int tx_enable, int phase_reset, int trigger_scan, int use_shape, int amp, int flags, int inst, int inst_data, double length);
SPINCORE_API int pb_set_num_points(int num_points);
SPINCORE_API int pb_set_scan_segments(int num_segments);
SPINCORE_API int pb_scan_count(int reset);
SPINCORE_API int pb_zero_ram(void);
SPINCORE_API int pb_overflow(int reset, PB_OVERFLOW_STRUCT *of);
SPINCORE_API int pb_get_data(int num_points, int *real_data, int *imag_data);
SPINCORE_API int pb_get_data_direct(int num_points, short *data);
SPINCORE_API int pb_write_ascii (char * fname, int num_points, float SW, int *real_data, int *imag_data);
SPINCORE_API int pb_write_ascii_verbose (char * fname, int num_points, float SW, float SF, int *real_data, int *imag_data);
SPINCORE_API int pb_write_jcamp(char * fname, int num_points, float SW, float SF, int *real_data, int *imag_data);
SPINCORE_API int pb_write_felix(char * fnameout, int num_points, float SaW, float SF, int *real_data, int *imag_data);
SPINCORE_API int pb_setup_filters(double spectral_width, int scan_repetitions, int cmd);
SPINCORE_API int pb_setup_cic (int dec_amount, int shift_amount, int m, int stages);
SPINCORE_API int pb_load_coef_file (int *coef, char *fname, int num_coefs);
SPINCORE_API int pb_setup_fir (int num_taps, int *coef, int shift_amount, int dec_amount);
SPINCORE_API int pb_set_radio_control(unsigned int control);
SPINCORE_API int pb_unset_radio_control (unsigned int control);
SPINCORE_API int pb_set_radio_hw(int adc_control, int dac_control);

SPINCORE_API int pb_dds_load(float *data, int device);
SPINCORE_API int pb_set_amp(float amp, int addr);

//PBDDS-300 functions

#define pb_inst_dds(FREQ, TX_PHASE, TX_ENABLE, PHASE_RESET, FLAGS, INST, INST_DATA, LENGTH) \
		pb_inst_radio(FREQ, 0, 0, TX_PHASE, TX_ENABLE, PHASE_RESET, 0, FLAGS, INST, INST_DATA, LENGTH); 

#define pb_inst_dds_shape(FREQ, TX_PHASE, TX_ENABLE, PHASE_RESET, USESHAPE, AMP, FLAGS, INST, INST_DATA, LENGTH) \
		 pb_inst_radio_shape(FREQ, 0, 0, TX_PHASE, TX_ENABLE, PHASE_RESET, 0, USESHAPE, AMP, FLAGS, INST, INST_DATA, LENGTH); 

// Legacy function names
SPINCORE_API void set_clock(double clock_freq);
SPINCORE_API int start_programming(int device);
SPINCORE_API int stop_programming(void);
SPINCORE_API int start_pb(void);
SPINCORE_API int stop_pb(void);
SPINCORE_API int set_freq(double freq);
SPINCORE_API int set_phase(double phase);
SPINCORE_API int read_status(void);

#ifdef __cplusplus
}
#endif

//RadioProcessor control word defines
#define TRIGGER             0x0001
#define PCI_READ            0x0002
#define BYPASS_AVERAGE      0x0004
#define NARROW_BW           0x0008
#define FORCE_AVG			0x0010
#define BNC0_CLK            0x0020
#define DO_ZERO             0x0040
#define BYPASS_CIC          0x0080
#define BYPASS_FIR          0x0100
#define BYPASS_MULT         0x0200
#define SELECT_AUX_DDS      0x0400
#define DDS_DIRECT          0x0800
#define SELECT_INTERNAL_DDS 0x1000
#define DAC_FEEDTHROUGH     0x2000
#define OVERFLOW_RESET      0x4000
#define RAM_DIRECT          0x8000|BYPASS_CIC|BYPASS_FIR|BYPASS_MULT

#ifdef PB24
#define pb_inst pb_inst_pbonly
#endif

#ifdef PBDDS
#define pb_inst pb_inst_tworf
#define PHASE_RESET 0x200
#endif

#ifdef PBESR
#define pb_inst pb_inst_pbonly
#endif

#ifdef PBESRPRO
#define pb_inst pb_inst_pbonly
#endif

#define ALL_FLAGS_ON	0x1FFFFF
#define ONE_PERIOD		0x200000
#define TWO_PERIOD		0x400000
#define THREE_PERIOD	0x600000
#define FOUR_PERIOD		0x800000
#define FIVE_PERIOD		0xA00000
#define SIX_PERIOD      0xC00000
#define ON				0xE00000

// maximum number of boards that can be supported
#define MAX_NUM_BOARDS 32

#endif /* #ifdef _SPINAPI_H */
