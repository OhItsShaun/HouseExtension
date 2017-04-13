import HouseCore

public extension HouseNetwork {
    
    /// Open the House Network and set up any necessary packages.
    public func open() {
        HouseNetwork.current().start()
    }
    
}

public extension HouseRuntime {
    
    /// Run the process as a House Extension.
    ///
    /// - Parameter process: The House Process to run.
    public static func run(process: HouseProcess) {
        HouseRuntime.run(process, as: .houseExtension)
    }
    
}
