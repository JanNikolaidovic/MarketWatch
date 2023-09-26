# MarketWatch101

## Interpreting ACF and PACF for ARIMA Model Order Selection

### ACF (Auto-Correlation Function) and PACF (Partial Auto-Correlation Function)

When modeling time series data, determining the appropriate order for an ARIMA model often involves understanding the ACF and PACF plots. They provide insights into the autocorrelation structure of your data, aiding in the decision of AR (AutoRegressive) and MA (Moving Average) terms.

### ACF Interpretation:
- **What it is:** ACF measures the correlation between an observation and another observation at a prior time step considering both direct and indirect dependencies.
- **Exponential Decay or Sine-Wave Pattern:** Suggests an AR term. The number of lags before the cutoff in the ACF hints the AR term's order.
- **Abrupt Cut-off:** Suggests an MA term. The number of lags before the cutoff in the ACF hints at the MA term's order.
- **Multiple Significant Lags:** If a series is slightly under-differenced, it's common to observe multiple significant lags.

### PACF Interpretation:
- **What it is:** PACF portrays only the direct relationship between an observation and its lag.
- **Exponential Decay or Sine-Wave Pattern:** Suggests an MA term. The number of lags before the cutoff in the PACF hints at the MA term's order.
- **Abrupt Cut-off:** Indicates an AR term. The number of lags before the cutoff in the PACF hints the AR term's order.

### Practical Implications:
- **PACF Observations:** Notable lags (e.g., 1st, 5th, 7th) can suggest starting with AR terms of order 1, 5, or 7.
- **ACF Observations:** If values appear significant, it might indicate non-stationarity. Once the series is stationary, significant lags in the ACF suggest MA terms. The exact number depends on the observed cutoff.

### Recommendation:
Begin with an ARIMA model of order `ARIMA(p,d,q)` where:
- `p` could be 1, 5, or 8 (from PACF).
- `d` is the differencing order to achieve stationarity.
- `q` might be inferred from where the ACF tapers off.

While ACF and PACF provide insights, model selection often involves experimentation with multiple orders and evaluating them based on criteria like AIC or BIC. 

Tools like `auto.arima()` in R offer automation in this process, assisting in determining the best-fitting model. It's recommended to use such tools as a sanity check or complementary approach to manual interpretations.

