//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct DateSheetView: View {
	@Binding var installDate: Date
	@Binding var removalDate: Date

    var body: some View {
        Text("Hello, World!")
    }


}


struct DateSheetView_Previews: PreviewProvider {
	// 3 days into the future
	static let future = Date(timeIntervalSinceNow: 259200)

    static var previews: some View {
		DateSheetView(installDate: .constant(Date()), removalDate: .constant(future))
    }
}
