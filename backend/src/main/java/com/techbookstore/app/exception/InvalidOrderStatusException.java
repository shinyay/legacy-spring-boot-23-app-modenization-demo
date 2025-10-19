package com.techbookstore.app.exception;

/**
 * Exception thrown when an invalid order status transition is attempted.
 */
public class InvalidOrderStatusException extends RuntimeException {
    
    public InvalidOrderStatusException(String message) {
        super(message);
    }
    
    public InvalidOrderStatusException(String currentStatus, String newStatus) {
        super(String.format("Invalid status transition from %s to %s", currentStatus, newStatus));
    }
}