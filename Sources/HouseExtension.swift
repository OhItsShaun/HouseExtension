import HouseCore

public extension HouseNetwork {
    
    public func open() {
        HouseNetwork.current().start()
    }
    
}
