`timescale 1ns / 1ps

module tb_bin2bcd;

    // 1. Declarar señales para conectar al TOP
    // Las entradas al sistema son 'reg' (porque nosotros las manipulamos)
    reg clk;
    reg reset;
    reg init;
    reg [15:0] bin_in;

    // Las salidas del sistema son 'wire' (porque solo las observamos)
    wire [19:0] bcd_out;
    wire done;

    // 2. Instanciar tu Módulo Principal (UUT - Unit Under Test)
    bin2bcd_top uut (
        .clk(clk), 
        .reset(reset), 
        .init(init), 
        .bin_in(bin_in), 
        .bcd_out(bcd_out), 
        .done(done)
    );

    // 3. Generador de Reloj (Tic-Tac constante)
    always #5 clk = ~clk; // Invierte el reloj cada 5ns (Periodo = 10ns)

    // 4. Proceso de Prueba (Aquí ocurre la acción)
    initial begin
        // Configuración para GTKWave (Esto crea el archivo de ondas)
        $dumpfile("simulacion.vcd"); // Nombre del archivo de salida
        $dumpvars(0, tb_bin2bcd);    // Guardar todas las variables

        // A) Inicialización
        clk = 0;
        reset = 1;
        init = 0;
        bin_in = 0;
        
        $display("--- Iniciando Simulacion ---");

        // B) Resetear el sistema
        #20;            // Esperar 20ns
        reset = 0;      // Soltar reset
        #10;

        // C) PRUEBA 1: Convertir el número 255
        // En BCD debería ser: 00255 (Hex: 00 02 55)
        $display("Test 1: Enviando 255 (Espere...)");
        bin_in = 16'd255; 
        init = 1;       // ¡Pulso de inicio!
        #10;            // Mantener init 1 ciclo
        init = 0;       // Soltar init

        // Esperar a que el sistema diga "Done"
        wait(done);     
        $display("Test 1 Terminado. Salida BCD (Hex): %h", bcd_out);
        #20;

        // D) PRUEBA 2: Convertir el número máximo 65535
        // En BCD debería ser: 65535
        $display("Test 2: Enviando 65535 (Espere...)");
        reset = 1; #10; reset = 0; // Reset rápido por seguridad
        bin_in = 16'd65535;
        init = 1;
        #10;
        init = 0;

        wait(done);
        $display("Test 2 Terminado. Salida BCD (Hex): %h", bcd_out);
        #50;

        $display("--- Fin de Simulacion ---");
        $finish; // Terminar simulación
    end

endmodule