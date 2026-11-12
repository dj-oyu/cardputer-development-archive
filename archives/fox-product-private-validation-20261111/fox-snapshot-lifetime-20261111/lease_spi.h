#ifndef LEASE_SPI_H
#define LEASE_SPI_H
#include "lease.h"
#include "freertos/FreeRTOS.h"
#include "driver/spi_master.h"
/* Isolated IDF v6.0.1 adapter, NOT wired to production board.
 * One owner task, dedicated device, return-result mode. Never from ISR.
 * No other code may reap this device. Descriptor storage must outlive drain.
 * No copy/move/reinit while active. Pin payload BEFORE driver submission.
 * Driver may use bounce buffers; allocation failure cannot release a borrow
 * on unknown outcomes. Payload must meet target DMA/caching requirements. */
typedef struct {spi_transaction_t descriptor;lease_pool*pool;lease_ticket ticket;bool active;} lease_spi_entry;
typedef struct {spi_device_handle_t device;lease_spi_entry entries[2];} lease_spi;
esp_err_t lease_spi_submit(lease_spi*,lease_pool*,lease_key,size_t payload_size,size_t offset,size_t bytes,TickType_t wait);
esp_err_t lease_spi_reap(lease_spi*,TickType_t wait);
bool lease_spi_idle(const lease_spi*);
#endif
