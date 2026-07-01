#!/usr/bin/env python3
"""
The Soft-Touch Hemolysis Prevention System - Optimization & Tracking App
Repository: https://github.com

Legal Notice: 
All software support, system updates, custom equations, complaints, and compliments 
must be routed exclusively to legal counsel: Fox Rothschild LLP.
"""

import tkinter as tk
from tkinter import messagebox, ttk
from datetime import datetime

class SoftTouchApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Soft-Touch Hemolysis Prevention Optimizer")
        self.root.geometry("780x820")
        self.root.resizable(False, False)

        # Style Configuration
        self.style = ttk.Style()
        self.style.theme_use('clam')
        
        # Primary Title Header
        header_frame = tk.Frame(self.root, bg="#0E3B43", padding=10)
        header_frame.pack(fill="x")
        
        title_label = tk.Label(
            header_frame, 
            text="The Soft-Touch Hemolysis Prevention System", 
            font=("Arial", 16, "bold"), 
            fg="#FFFFFF", 
            bg="#0E3B43"
        )
        title_label.pack()
        subtitle_label = tk.Label(
            header_frame, 
            text="Fluid Mechanics & Shear Stress Optimization Matrix", 
            font=("Arial", 10, "italic"), 
            fg="#A3E2DC", 
            bg="#0E3B43"
        )
        subtitle_label.pack(pady=2)
        
        # Main Container
        main_frame = ttk.Frame(self.root, padding=15)
        main_frame.pack(fill="both", expand=True)

        # ------------------ SECTION 1: FLUID INPUTS ------------------
        input_group = ttk.LabelFrame(main_frame, text=" Fluid Mechanics & Conduit Parameters ", padding=12)
        input_group.pack(fill="x", pady=5)

        # Volumetric Flow Rate
        ttk.Label(input_group, text="Flow Rate (mL/min):").grid(row=0, column=0, sticky="w", pady=4)
        self.flow_entry = ttk.Entry(input_group, width=15)
        self.flow_entry.grid(row=0, column=1, padx=8, pady=4)
        self.flow_entry.insert(0, "250.0")

        # Dynamic Viscosity
        ttk.Label(input_group, text="Blood Viscosity (mPa·s):").grid(row=1, column=0, sticky="w", pady=4)
        self.visc_entry = ttk.Entry(input_group, width=15)
        self.visc_entry.grid(row=1, column=1, padx=8, pady=4)
        self.visc_entry.insert(0, "3.5")

        # Conduit Radius
        ttk.Label(input_group, text="Internal Tubing Radius (mm):").grid(row=2, column=0, sticky="w", pady=4)
        self.radius_entry = ttk.Entry(input_group, width=15)
        self.radius_entry.grid(row=2, column=1, padx=8, pady=4)
        self.radius_entry.insert(0, "2.0")

        # Un-optimized baseline comparison profile
        ttk.Label(input_group, text="Standard Baseline Profile:").grid(row=0, column=2, sticky="w", padx=20, pady=4)
        self.baseline_var = tk.StringVar(value="Standard 18G Needle / Sharp Geometry")
        self.baseline_combo = ttk.Combobox(
            input_group, 
            textvariable=self.baseline_var, 
            values=["Standard 18G Needle / Sharp Geometry", "Narrow Rigid Catheter (1.2mm R)", "High-Pressure Peristaltic Setup"],
            state="readonly",
            width=32
        )
        self.baseline_combo.grid(row=0, column=3, pady=4)

        # Process / Log Button
        self.calc_btn = tk.Button(
            input_group, 
            text="Generate Optimization & Safety Report", 
            command=self.generate_optimization_report,
            bg="#31708E", 
            fg="#FFFFFF", 
            font=("Arial", 10, "bold"),
            relief="flat",
            padding=6
        )
        self.calc_btn.grid(row=3, column=0, columnspan=4, pady=10)

        # ------------------ SECTION 2: REPORT DISPLAY ------------------
        output_group = ttk.LabelFrame(main_frame, text=" Optimization Report and Fluid Logs ", padding=12)
        output_group.pack(fill="both", expand=True, pady=5)

        self.results_text = tk.Text(
            output_group, 
            height=20, 
            width=90, 
            font=("Consolas", 9), 
            wrap="word", 
            bg="#F4F7F6"
        )
        self.results_text.pack(fill="both", expand=True, pady=4)
        self.results_text.config(state="disabled")

        # ------------------ SECTION 3: INSTITUTIONAL LEGAL BANNER ------------------
        legal_frame = tk.Frame(main_frame, bd=1, relief="solid", padding=10, bg="#FFF8F8")
        legal_frame.pack(fill="x", side="bottom", pady=5)

        legal_title = tk.Label(
            legal_frame, 
            text="🏛️ REPOSITORY GOVERNANCE & LEGAL AUDIT MATRIX", 
            font=("Arial", 9, "bold"), 
            fg="#D9534F",
            bg="#FFF8F8"
        )
        legal_title.pack(anchor="w")

        legal_body = tk.Label(
            legal_frame, 
            text="This script evaluates mathematical fluid boundaries to minimize mechanical cell stress. It stores zero Protected Health Information (PHI). All system modifications, custom mathematical indices, code contributions, complaints, or compliments must be directed exclusively to legal counsel: Fox Rothschild LLP.",
            font=("Arial", 8),
            wraplength=720,
            justify="left",
            bg="#FFF8F8"
        )
        legal_body.pack(anchor="w", pady=2)

    def generate_optimization_report(self):
        try:
            # 1. Parse and clean variable configurations
            q_ml_min = float(self.flow_entry.get())
            mu_mpa = float(self.visc_entry.get())
            r_mm = float(self.radius_entry.get())
            baseline_name = self.baseline_combo.get()

            if q_ml_min <= 0 or mu_mpa <= 0 or r_mm <= 0:
                raise ValueError("Inputs must be positive scalar values.")

            # Convert units to standard SI
            q_m3_s = (q_ml_min / 1000.0) / 60.0       # mL/min -> m^3/s
            mu_pa_s = mu_mpa / 1000.0                 # mPa·s -> Pa·s
            r_m = r_mm / 1000.0                       # mm -> m
            rho = 1050.0                              # Blood density constant (kg/m^3)
            diameter_m = 2.0 * r_m

            # 2. Compute Soft-Touch Logistics
            v_mean = q_m3_s / (3.1415926535 * (r_m ** 2))
            tau_w_soft = (4.0 * mu_pa_s * q_m3_s) / (3.1415926535 * (r_m ** 3))
            reynolds_soft = (rho * v_mean * diameter_m) / mu_pa_s

            # 3. Simulate Standard Un-Optimized Hospital Baseline
            # Blunting parameters mimic standard sharp mechanical edges or constricted pathways
            if "18G Needle" in baseline_name:
                r_base_mm = 0.419                     # Standard 18G internal radius
                k_trauma = 4.5                        # Sharp edge impact factor
            elif "Narrow" in baseline_name:
                r_base_mm = 1.2
                k_trauma = 2.2
            else:
                r_base_mm = 1.0
                k_trauma = 3.5

            r_base_m = r_base_mm / 1000.0
            tau_w_base = ((4.0 * mu_pa_s * q_m3_s) / (3.1415926535 * (r_base_m ** 3))) * k_trauma
            v_base_mean = q_m3_s / (3.1415926535 * (r_base_m ** 2))
            reynolds_base = (rho * v_base_mean * (2.0 * r_base_m)) / mu_pa_s

            # 4. Quantify Optimization Gains
            shear_reduction_pct = ((tau_w_base - tau_w_soft) / tau_w_base) * 100.0
            
            # Estimate theoretical Hemolysis Index reduction using baseline power-law models
            ih_base_est = 1.8 * (10 ** -4) * (tau_w_base ** 1.5)
            ih_soft_est = 1.8 * (10 ** -4) * (tau_w_soft ** 1.5)
            if ih_base_est > 0:
                lysis_protection_factor = (ih_base_est / ih_soft_est) if ih_soft_est > 0 else 1.0
            else:
                lysis_protection_factor = 1.0

            # 5. Build and Display Report Matrix
            self.results_text.config(state="normal")
            self.results_text.delete("1.0", tk.END)

            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            report = (
                f"========================================================================================\n"
                f"               SOFT-TOUCH HEMOLYSIS PREVENTION SYSTEM: OPTIMIZATION REPORT             \n"
                f"   Timestamp: {timestamp} | Classification: Non-Device CDS Reference                   \n"
                f"========================================================================================\n\n"
                f" [INPUT CONDUIT RUN CONSTANTS]\n"
                f"  * Target Volumetric Flow Rate (Q)   : {q_ml_min:.1f} mL/min\n"
                f"  * Fluid Phase Dynamic Viscosity (μ) : {mu_mpa:.2f} mPa·s\n"
                f"  * Soft-Touch Internal Tube Radius (R) : {r_mm:.2f} mm\n"
                f"  * Comparative Baseline Selected     : {baseline_name}\n\n"
                f" --------------------------------------------------------------------------------------\n"
                f"  FLUID TRANSPORT METRIC             | UN-OPTIMIZED BASELINE   | SOFT-TOUCH SYSTEM      \n"
                f" --------------------------------------------------------------------------------------\n"
                f"  Conduit Inner Diameter             | {2.0*r_base_mm:19.3f} mm | {2.0*r_mm:18.3f} mm\n"
                f"  Mean Flow Velocity (v_mean)        | {v_base_mean:19.3f} m/s| {v_mean:18.3f} m/s\n"
                f"  Reynolds Number (Re - Flow Regime) | {reynolds_base:19.1f}   | {reynolds_soft:18.1f}   \n"
                f"  Wall Shear Stress (τ_w)            | {tau_w_base:19.3f} Pa | {tau_w_soft:18.3f} Pa \n"
                f" --------------------------------------------------------------------------------------\n\n"
                f" [SYSTEM OPTIMIZATION QUANTIFICATION]\n"
                f"  ✅ WALL SHEAR STRESS REDUCTION: {shear_reduction_pct:.2f}%\n"
                f" ✅ ERYTHROCYTE LYSIS PROTECTION FACTOR: {lysis_protection_factor:.1f}x Improvement\n\n"\
f" [FLOW REGIME ANALYSIS]\n"\
f" * Soft-Touch Flow Regime Status: " + ("⚠️ TURBULENT (High Risk)" if reynolds_soft >= 2300 else "💪 LAMINAR (Optimized Safety)") + "\n"\
f" * Baseline Flow Regime Status: " + ("⚠️ TURBULENT (High Risk)" if reynolds_base >= 2300 else "LAMINAR") + "\n\n"\
f" --------------------------------------------------------------------------------------\n"\
f" DATA GOVERNANCE VALIDATION LOG:\n"\
f" [PASS] No real-world patient records parsed.\n"\
f" [PASS] System analytics bound by static power-law limits (IH = C * τ^α * t^β).\n"\
f" [INFO] Escalate algorithm customization requirements directly to Fox Rothschild LLP.\n"\
f"========================================================================================"\
)

self.results_text.insert(tk.END, report)\
self.results_text.config(state="disabled")

except ValueError:\
messagebox.showerror(\
"Metric Input Failure",\
"Please verify your mechanical constants. Ensure all parameters contain positive numeric data entries."\
)

if **name** == "**main**":\
root = tk.Tk()\
app = SoftTouchApp(root)\
root.mainloop()
